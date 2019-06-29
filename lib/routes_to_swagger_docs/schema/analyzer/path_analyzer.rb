# frozen_string_literal: true

require_relative 'base_analyzer'
require_relative '../manager/file/path_item_file_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class PathAnalyzer < BaseAnalyzer
      def update_from_schema
        sorted_schema = deep_sort(@after_schema_data, 'paths')
        edited_paths_schema = sorted_schema['paths']

        save_each_tags(edited_paths_schema) do |tag_name, result|
          file_manager = PathItemFileManager.new("paths/#{tag_name}", :relative)
          file_manager.save(result.to_yaml)
          logger.info "  Write schema file: \t#{file_manager.save_file_path}"
        end
      end

      private

      def unit_paths_data_group_by_tags(unit_paths_data)
        unit_paths_data.each_with_object({}) do |(path, data_when_path), result|
          data_when_path.each do |verb, data_when_verb|
            tag_name = data_when_verb['tags'].first
            result[tag_name] ||= {}
            result[tag_name].deep_merge!(
              'paths' => {
                path => {
                  verb => data_when_verb
                }
              }
            )
          end
        end
      end

      def save_each_tags(unit_paths_data)
        unit_paths_data_group_by_tags(unit_paths_data).each do |tag_name, result|
          yield [tag_name, result] if block_given?
        end
      end
    end
  end
end
