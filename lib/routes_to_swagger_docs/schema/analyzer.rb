require_relative 'analyzer/base_analyzer'
require_relative 'analyzer/path_analyzer'

module RoutesToSwaggerDocs
  module Schema
    class Analyzer < BaseAnalyzer
      def initialize(edited_schema_file_path, options = {})
        super(edited_schema_file_path, options)
        @path_analyzer = PathAnalyzer.new(edited_schema_file_path, options)
      end

      def update_schema
        @edited_schema.each do |schema_name, value|
          if schema_name.eql? "paths"
            @path_analyzer.update_schema
          else
            full_save_file_path = "#{schema_save_dir_path}/#{schema_name}.yml"
            schema_from_local = YAML.load_file(full_save_file_path)
            result = schema_from_local.deep_merge @edited_schema.slice(schema_name)
            File.write(full_save_file_path, result.to_yaml)
          end
        end
      end
    end
  end
end