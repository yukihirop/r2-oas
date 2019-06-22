require_relative 'base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class PathAnalyzer < BaseAnalyzer
      def update_from_schema
        sorted_schema = deep_sort(@after_schema_data, "paths")
        edited_paths_schema = sorted_schema["paths"]

        save_each_tags(edited_paths_schema) do |tag_name, result|
          dirs = "paths"
          filename_with_namespace = tag_name
          save_path = save_path_for(filename_with_namespace, dirs)
          File.write(save_path, result.to_yaml)
          logger.info "  Write schema file: \t#{save_path}"
        end
      end

      private

      def unit_paths_data_group_by_tags(unit_paths_data)
        unit_paths_data.each_with_object({}) do |(path, data_when_path), result|
          data_when_path.each do |verb, data_when_verb|
            tag_name = data_when_verb["tags"].first
            result[tag_name] ||= {}
            result[tag_name].deep_merge!({
              "paths" => {
                path => {
                  verb => data_when_verb
                }
              }
            })
          end
        end
      end

      def save_each_tags(unit_paths_data, &block)
        unit_paths_data_group_by_tags(unit_paths_data).each do |tag_name, result|
          yield *[tag_name, result] if block_given?
        end
      end
    end
  end
end