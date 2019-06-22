require 'easy_diff'

require_relative '../../errors'
require_relative '../base'
require_relative '../../shared/all'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class BaseAnalyzer < Base
      include Searchable
      include Sortable
      include Writable

      def initialize(before_schema_data, after_schema_data = {}, options = {})
        super({}, options)
        @type = options[:type].presence
        @before_schema_data = before_schema_data
        @after_schema_data  = after_schema_data || create_after_schema_data
      end

      def update_from_schema
        raise NoImplementError
      end

      def generate_from_existing_schema
        raise NoImplementError
      end

      private

      attr_accessor :edited_schema_file_path
      attr_accessor :existing_schema_file_path
      attr_accessor :type

      def create_after_schema_data
        case @type
        when :edited
          YAML.load_file(edited_schema_file_path)
        when :existing
          extname = File.extname(existing_schema_file_path)
          case extname
          when /json/
            File.open(existing_schema_file_path) do |file|
              JSON.load(file)
            end
          when /yaml/
            YAML.load_file(existing_schema_file_path)
          when /yml/
            YAML.load_file(existing_schema_file_path)
          else
            raise 'Do not support extension'
          end
        end
      end
    end
  end
end