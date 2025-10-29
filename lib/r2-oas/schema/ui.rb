# frozen_string_literal: true

require 'docker'
require 'watir'
require 'forwardable'

# Scope Rails
module R2OAS
  module Schema
    class UI < Base
      extend Forwardable

      alias swagger_json doc_save_file_path

      def initialize(options = {})
        super
        @ui = swagger.ui
        @running = false
      end

      def start
        @running = true
        container.start
        open_browser

        puts "\nPress Ctrl+C to stop..."
        setup_signal_traps

        # メインスレッドを待機状態に保つ
        sleep 0.1 while @running

        # ループを抜けたら安全なコンテキストでクリーンアップ
        cleanup
      end

      private

      attr_accessor :unit_paths_file_path
      def_delegators :@ui, :image, :port, :url, :exposed_port, :volume

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
        container.stop
        container.remove
        logger.info "container id: #{container.id} removed"
        @browser&.close
      end

      def open_browser
        @browser ||= Watir::Browser.new
        @browser.goto(url)
        wait_for_loaded
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
            'Binds' => ["#{swagger_json}:#{volume}"]
          },
          'Volumes' => { volume => {} }
        )
      end
    end
  end
end
