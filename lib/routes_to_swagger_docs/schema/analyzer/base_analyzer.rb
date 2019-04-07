require_relative '../../errors'
require_relative '../base'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class BaseAnalyzer < Base
      def initialize(options = {})
        super(options)
        @edited_schema = YAML.load_file(edited_schema_file_path) 
      end

      def update_schema
        raise NoImplementError
      end

      private

      attr_accessor :edited_schema_file_path

      def schema_save_dir_path
        File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
      end
    end
  end
end