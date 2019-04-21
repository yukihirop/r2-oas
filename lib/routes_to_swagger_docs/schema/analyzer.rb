require_relative 'analyzer/base_analyzer'
require_relative 'analyzer/path_analyzer'
require_relative 'analyzer/tag_analyzer'
require_relative 'analyzer/components_analyzer'

module RoutesToSwaggerDocs
  module Schema
    class Analyzer < BaseAnalyzer
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @path_analyzer = PathAnalyzer.new(schema_data, options)
        @tag_analyzer = TagAnalyzer.new(schema_data, options)
        @components_analyzer = ComponentsAnalyzer.new(schema_data, options)
      end

      def update_schema
        @edited_schema.each do |schema_name, _|
          case schema_name
          when "paths"
            @path_analyzer.update_schema
          when "tags"
            @tag_analyzer.update_schema
          when "components"
            @components_analyzer.update_schema
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