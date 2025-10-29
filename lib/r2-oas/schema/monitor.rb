# frozen_string_literal: true

# Scope Rails
module R2OAS
  module Schema
    class Monitor < Base
      def initialize(before_schema_data, options)
        super(options)
        @before_schema_data = before_schema_data
        @running = false
      end

      def start
        @running = true
        @after_schema_data = @before_schema_data

        puts "\nPress Ctrl+C to stop..."
        setup_signal_traps

        # メインスレッドを待機状態に保つ
        monitor_loop

        # ループを抜けたら安全なコンテキストでクリーンアップ
        process_after_close_monitor
      end

      private

      attr_accessor :unit_paths_file_path

      def setup_signal_traps
        %w[INT TERM].each do |signal|
          Signal.trap(signal) do
            # シグナルトラップ内では重い処理（ミューテックス等）を行わない
            # メインループを終了させ、終了後にクリーンアップを行う
            @running = false
          end
        end
      end

      def monitor_loop
        puts "\nwait for signal trap ..."
        last_check_time = Time.now

        while @running
          sleep 0.1

          # 一定間隔で監視処理を実行
          current_time = Time.now
          if current_time - last_check_time >= interval_to_save_edited_tmp_schema
            @after_schema_data = fetch_after_schema_data
            last_check_time = current_time
          end
        end
      end

      def process_after_close_monitor
        @running = false
        options = { type: :edited }
        @after_schema_data = fetch_after_schema_data
        analyzer = Analyzer.new(@before_schema_data, @after_schema_data, options)
        analyzer.analyze_docs
      end

      def fetch_after_schema_data
        YAML.load_file(doc_save_file_path) || @after_schema_data
      end
    end
  end
end
