require_relative '../../errors'
require_relative '../base'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class BaseAnalyzer < Base
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @schema = YAML.load_file(edited_schema_file_path)
      end

      def update_from_schema
        raise NoImplementError
      end

      private

      attr_accessor :edited_schema_file_path
    end
  end
end