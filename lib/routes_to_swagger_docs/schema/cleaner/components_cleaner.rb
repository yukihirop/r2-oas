# frozen_string_literal: true

require_relative 'base_cleaner'
require_relative '../manager/file/path_item_file_manager'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsCleaner < BaseCleaner
      def initialize(options = {})
        super
        @schemas_file_paths        = Dir.glob("#{schema_save_dir_path}/components/schemas/**/**.yml")
        @request_bodies_file_paths = Dir.glob("#{schema_save_dir_path}/components/requestBodies/**/**.yml")
      end

      def clean_docs
        logger.info '[Clean Swagger file (components)] start'
        super do |file_path|
          logger.info "  Delete schema file: \t#{file_path}"
        end
        logger.info '[Clean Swagger file (components)] end'
      end

      private

      def clean_target_files
        used_file_paths = many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
          file_manager = Schema::PathItemFileManager.new(unit_paths_path, :full)
          components_file_paths_at_path = file_manager.descendants_ref_paths
          result.push(*components_file_paths_at_path)
        end.uniq

        all_file_paths - used_file_paths
      end

      def all_file_paths
        (@schemas_file_paths + @request_bodies_file_paths).uniq
      end
    end
  end
end
