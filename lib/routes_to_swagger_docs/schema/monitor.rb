# frozen_string_literal:true

require 'eventmachine'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Monitor < Base
      def initialize(before_schema_data, options)
        super(options)
        @before_schema_data = before_schema_data
      end

      def start
        EM.run do
          ensure_save_tmp_schema_file
          signal_trap('INT')
          signal_trap('TERM')
        end
      end

      private

      attr_accessor :unit_paths_file_path

      def signal_trap(command)
        Signal.trap(command) do
          process_after_close_monitor
          EM.stop
        end
      end

      def process_after_close_monitor
        options = { type: :edited }
        @after_schema_data = fetch_after_schema_data
        analyzer = Analyzer.new(@before_schema_data, @after_schema_data, options)
        analyzer.analyze_docs
      end

      def ensure_save_tmp_schema_file
        EM.add_periodic_timer(interval_to_save_edited_tmp_schema) do
          @after_schema_data = fetch_after_schema_data
          puts "\nwait for signal trap ..."
        end
      end

      def fetch_after_schema_data
        YAML.load_file(doc_save_file_path) || @after_schema_data
      end
    end
  end
end
