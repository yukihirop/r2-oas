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

      def update_from_schema
        @schema.each do |schema_name, _|
          case schema_name
          when "paths"
            @path_analyzer.update_from_schema
          when "tags"
            @tag_analyzer.update_from_schema
          when "components"
            @components_analyzer.update_from_schema
          else
            save_schema_from(schema_name)
          end
        end
      end

      private

      def save_schema_from(schema_name)
        case @type
        when :edited
          save_path = save_path_for(schema_name)
          schema_from_local = YAML.load_file(save_path)
          result = schema_from_local.deep_merge @schema.slice(schema_name)
          File.write(save_path, result.to_yaml)
        when :existing
          save_path = save_path_for(schema_name)
          result = @schema.slice(schema_name)
          File.write(save_path, result.to_yaml)
        end
      end
    end
  end
end