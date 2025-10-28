# frozen_string_literal:true

require 'docker'
require 'watir'
require 'tempfile'
require 'fileutils'
require 'forwardable'

# Can't use ActiveSupport::Autroload
# ThreadError: can't be called from trap context
require 'r2-oas/schema/analyzer'
require_relative 'base'

# Scope Rails
module R2OAS
  module Schema
    class Editor < Base
      extend Forwardable

      TMP_FILE_NAME = 'edited_schema'
      ALERT_TEXT = 'Would you like to convert your JSON into YAML?'

      attr_accessor :edited_schema

      def initialize(before_schema_data, options)
        super(options)
        @editor = swagger.editor
        @before_schema_data = before_schema_data
        @schema_doc_from_local = YAML.load_file(doc_save_file_path).to_yaml
        @running = false
      end

      def start
        @running = true
        container.start
        open_browser_and_set_schema
        ensure_save_tmp_schema_file
        
        puts "\nPress Ctrl+C to stop..."
        setup_signal_traps
        
        # メインスレッドを待機状態に保つ
        sleep 0.1 while @running

        # ループを抜けたら安全なコンテキストでクリーンアップ
        cleanup
      end

      private

      attr_accessor :unit_paths_file_path
      def_delegators :@editor, :storage_key, :image, :port, :url, :exposed_port

      def setup_signal_traps
        %w[INT TERM].each do |signal|
          Signal.trap(signal) do
            # シグナルトラップ内では重い処理（ミューテックス等）を行わない
            # メインループを終了させ、終了後にクリーンアップを行う
            @running = false
          end
        end
      end

      def cleanup
        @running = false
        @save_thread&.join(1) # スレッドの終了を待つ（最大1秒）
        # ブラウザセッションの状態に依らず必ず後処理を実行する
        begin
          process_after_close_browser
        rescue StandardError => e
          logger.warn("post close process failed: #{e.class}: #{e.message}")
        end
        container.stop
        container.remove
        logger.info "container id: #{container.id} removed"
        @browser&.close
      end

      def process_after_close_browser
        # 可能ならブラウザから取得、ダメなら最後に保存されたファイルを使う
        begin
          fetch_edited_schema_from_browser
        rescue StandardError
          # ignore
        end
        @after_schema_data ||= (File.read(doc_save_file_path) rescue nil)
        return unless @after_schema_data

        options = { type: :edited }
        save_edited_schema
        conv_after_schema_data = YAML.load(@after_schema_data)
        analyzer = Analyzer.new(@before_schema_data, conv_after_schema_data, options)
        analyzer.analyze_docs
        $stdout.flush
      end

      # MEMO
      # TargetRubyVersion is 2.7 and there is a warning
      # Because it is necessary to support from ruby2.3 series where begin cannot be omitted
      # rubocop:disable Style/RedundantBegin
      def ensure_save_tmp_schema_file
        @save_thread = Thread.new do
          while @running
            # ブラウザが閉じられていても継続する
            m = Mutex.new
            m.synchronize do
              begin
                save_after_fetch_local_strage
              rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
                alert = @browser.driver.switch_to.alert
                if alert.text.eql?(ALERT_TEXT)
                  alert.accept && save_after_fetch_local_strage
                end
              rescue StandardError
                # ブラウザが無い/取得失敗時はスキップ
              end
            end
            
            sleep interval_to_save_edited_tmp_schema
          end
        end
      end
      # rubocop:enable Style/RedundantBegin

      def save_after_fetch_local_strage
        @after_schema_data = get_local_storage(storage_key) || @after_schema_data
        save_edited_schema
        puts "\nwait for signal trap ..."
      end

      def fetch_edited_schema_from_browser
        @after_schema_data = get_local_storage(storage_key)
      end

      def save_edited_schema
        File.write(doc_save_file_path, @after_schema_data)
      end

      def open_browser_and_set_schema
        @browser ||= Watir::Browser.new(:chrome)
        @browser.goto(url)
        if wait_for_loaded
          # MEMO:
          # Because it may not be updated
          # Make sure that the launched local storage is updated reliably
          Watir::Wait.until do
            old_storage = (get_local_storage(storage_key) || '').dup
            set_local_storage(storage_key, new_storage = @schema_doc_from_local)
            old_storage != new_storage
          end
          @browser.refresh
        end
      end

      def get_local_storage(key)
        return nil unless @browser
        @browser.execute_script('return window.localStorage.getItem(arguments[0]);', key)
      end

      def set_local_storage(key, value)
        @browser.execute_script('window.localStorage.setItem(arguments[0], arguments[1]);', key, value)
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
      end

      def container
        @container ||= Docker::Container.create(
          'Image' => image,
          'ExposedPorts' => { exposed_port => {} },
          'HostConfig' => {
            'PortBindings' => {
              exposed_port => [{ 'HostPort' => port }]
            }
          }
        )
      end
    end
  end
end
