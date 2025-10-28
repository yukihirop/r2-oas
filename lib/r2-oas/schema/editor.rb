# frozen_string_literal:true

require 'docker'
require 'watir'
require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'digest'
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
        @chrome_user_data_dir = Dir.mktmpdir('r2oas_chrome_profile_')
      end

      def start
        @running = true
        ensure_host_mount_target
        container.start
        log_container_mount_info
        log_host_mount_file_state('startup')
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
      def log_container_mount_info
        begin
          info = container.json
          mounts = info['Mounts'] || []
          mapped = mounts.map { |m| "#{m['Source']} -> #{m['Destination']} (type=#{m['Type']})" }
          logger.info("editor mounts: #{mapped.join(', ')}")

          check_cmd = [
            'sh', '-lc',
            "if [ -e #{editor_volume_path} ]; then echo '[exists]'; ls -l #{editor_volume_path}; echo -n 'size(bytes): '; wc -c < #{editor_volume_path}; else echo '[missing]'; fi 2>&1 || true"
          ]
          out, _err, _status = container.exec(check_cmd) rescue [[], [], nil]
          logger.info("editor_volume_path: #{editor_volume_path}\n#{Array(out).join}")
        rescue StandardError => e
          logger.warn("failed to log editor mounts: #{e.class}: #{e.message}")
        end
      end

      def log_host_mount_file_state(prefix = nil)
        begin
          if File.exist?(doc_save_file_path)
            size = File.size(doc_save_file_path)
            mtime = File.mtime(doc_save_file_path)
            logger.info("#{prefix} host file: #{doc_save_file_path} size=#{size} mtime=#{mtime}")
          else
            logger.info("#{prefix} host file missing: #{doc_save_file_path}")
          end
        rescue StandardError => e
          logger.warn("failed to log host file state: #{e.class}: #{e.message}")
        end
      end
      def ensure_host_mount_target
        # bind mount の対象ファイルは事前に存在している必要がある
        dir = File.dirname(doc_save_file_path)
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
        File.write(doc_save_file_path, '') unless File.exist?(doc_save_file_path)
      end

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
        # containerからマウントファイルを読み込む
        edited_data = read_edited_data_from_container
        
        return unless edited_data

        @after_schema_data = edited_data
        options = { type: :edited }
        save_edited_schema
        conv_after_schema_data = YAML.load(@after_schema_data)
        analyzer = Analyzer.new(@before_schema_data, conv_after_schema_data, options)
        analyzer.analyze_docs
        $stdout.flush
      end
      
      def read_edited_data_from_container
        # containerのマウントファイルから読み込み
        container.read_file(editor_volume_path) rescue nil
      end

      # MEMO
      # TargetRubyVersion is 2.7 and there is a warning
      # Because it is necessary to support from ruby2.3 series where begin cannot be omitted
      # rubocop:disable Style/RedundantBegin
      def ensure_save_tmp_schema_file
        @save_thread = Thread.new do
          while @running
            m = Mutex.new
            m.synchronize do
              begin
                # 1秒ごとにローカルストレージから取得してcontainer内のファイルに保存
                data = get_local_storage(storage_key)
                log_local_storage_state
                if data
                  digest = Digest::SHA256.hexdigest(data)
                  if digest != (@last_saved_digest || '')
                    File.write(doc_save_file_path, data)
                    @last_saved_digest = digest
                    log_host_mount_file_state('autosave')
                    logger.info("autosave wrote: bytes=#{data.bytesize} sha256=#{digest[0,8]}...")
                  else
                    logger.info("autosave skipped (unchanged): bytes=#{data.bytesize} sha256=#{digest[0,8]}...")
                  end
                else
                  logger.info('autosave skipped: storage value is nil')
                end
              rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
                alert = @browser&.driver&.switch_to&.alert
                if alert&.text&.eql?(ALERT_TEXT)
                  alert.accept
                  data = get_local_storage(storage_key)
                  if data
                    digest = Digest::SHA256.hexdigest(data)
                    if digest != (@last_saved_digest || '')
                      File.write(doc_save_file_path, data)
                      @last_saved_digest = digest
                      log_host_mount_file_state('autosave')
                      logger.info("autosave wrote (after alert): bytes=#{data.bytesize} sha256=#{digest[0,8]}...")
                    end
                  end
                end
              rescue StandardError => e
                # ブラウザが無い/取得失敗時はスキップ
              end
            end
            
            sleep interval_to_save_edited_tmp_schema
          end
        end
      end
      
      def save_data_to_container(data)
        container.store_file(editor_volume_path, data) rescue nil
      end
      # rubocop:enable Style/RedundantBegin

      def fetch_edited_schema_from_browser
        @after_schema_data = get_local_storage(storage_key)
      end

      def save_edited_schema
        File.write(doc_save_file_path, @after_schema_data)
      end

      def open_browser_and_set_schema
        @browser ||= Watir::Browser.new(:chrome, options: chrome_options)
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

      def chrome_options(headless: false)
        opts = Selenium::WebDriver::Chrome::Options.new
        opts.add_argument("--user-data-dir=#{@chrome_user_data_dir}")
        opts.add_argument('--disable-dev-shm-usage')
        opts.add_argument('--no-sandbox')
        opts.add_argument('--headless=new') if headless
        opts
      end

      def get_local_storage(key)
        return nil unless @browser
        @browser.execute_script('return window.localStorage.getItem(arguments[0]);', key)
      end

      def set_local_storage(key, value)
        @browser.execute_script('window.localStorage.setItem(arguments[0], arguments[1]);', key, value)
      end

      def log_local_storage_state
        return unless @browser
        begin
          keys = @browser.execute_script('return Object.keys(window.localStorage);')
          val = @browser.execute_script('return window.localStorage.getItem(arguments[0]);', storage_key)
          size = val ? val.bytesize : 0
          logger.info("localStorage keys=#{Array(keys).join(', ')} target=#{storage_key} bytes=#{size}")
        rescue StandardError
        end
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
            },
            'Binds' => ["#{doc_save_file_path}:#{editor_volume_path}"]
          },
          'Volumes' => { editor_volume_path => {} }
        )
      end
      
      def editor_volume_path
        '/tmp/swagger-editor-content.yml'
      end
    end
  end
end
