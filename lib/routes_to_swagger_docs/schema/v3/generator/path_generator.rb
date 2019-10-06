# frozen_string_literal: true

require 'forwardable'
require 'fileutils'
require_relative 'base_generator'
require_relative '../manager/file/path_item_file_manager'

module RoutesToSwaggerDocs
  module Schema
    class PathGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(options)
        sorted_schema_data = deep_sort(schema_data, 'paths')
        @paths = sorted_schema_data['paths']
        @glob_schema_paths = create_glob_paths_paths
      end

      def generate_docs
        if paths_file_do_not_exists?
          logger.info ' <From routes data>'
          generate_docs_from_routes_data
        else
          logger.info ' <From schema files>'
          generate_docs_from_schema_fiels
        end
      end

      private

      alias paths_files_paths schema_files_paths
      alias paths_file_do_not_exists? schema_file_do_not_exists?

      def generate_docs_from_schema_fiels
        process_when_generate_docs do |save_file_path|
          logger.info "  Merge schema file: \t#{save_file_path}"
        end
      end

      def generate_docs_from_routes_data
        process_when_generate_docs do |save_file_path|
          logger.info "  Write schema file: \t#{save_file_path}"
        end
      end

      def process_when_generate_docs
        logger.info ' <Update schema files (paths)>'
        save_each_tags(@paths) do |tag_name, result|
          relative_path = "paths/#{tag_name}"
          path_item_file_manager = PathItemFileManager.new(relative_path, :relative)

          path_item_file_manager.save(result.to_yaml) unless path_item_file_manager.skip_save?

          yield path_item_file_manager.save_file_path if block_given?
        end
      end

      def create_glob_paths_paths
        if many_paths_file_paths.present? && !skip_load_dot_paths
          many_paths_file_paths
        else
          ["#{schema_save_dir_path}/paths/**/**.yml"]
        end
      end

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
