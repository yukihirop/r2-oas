require_relative 'base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class PathAnalyzer < BaseAnalyzer
      def update_schema
        edited_paths_schema = @edited_schema["paths"]

        edited_schema_tag_names = edited_paths_schema.values.map do |data_when_path|
          first_data_when_verb = data_when_path.values.first
          # Support single tag.
          # tag_name is path for schema yaml file.
          tag_name = first_data_when_verb["tags"].first
        end.uniq

        edited_schema_tag_names.each do |tag_name|
          path_schema = PathSchema.new(edited_paths_schema, tag_name, schema_save_dir_path)
          unit_paths_only_specify_tags = path_schema.only_specify_tags

          dirs = "paths"
          filename_with_namespace = tag_name
          save_path = save_path_for(filename_with_namespace, dirs)
          File.write(save_path, unit_paths_only_specify_tags.to_yaml)
        end
      end

      private

      class PathSchema
        def initialize(paths_schema, tag_name, schema_save_dir_path)
          @paths_schema = paths_schema
          @tag_name = tag_name
          @schema_save_dir_path = schema_save_dir_path
        end

        def only_specify_tags
          unit_paths = @paths_schema.each_with_object({}) do |(path, data_when_path), result|
            data_when_path.values.each do |data_when_verb|
              include_tag_name = data_when_verb["tags"].include?(@tag_name)
              result.deep_merge!({ "#{path}" => data_when_path }) if include_tag_name
            end
          end
          { "paths" => unit_paths }
        end
      end
    end
  end
end