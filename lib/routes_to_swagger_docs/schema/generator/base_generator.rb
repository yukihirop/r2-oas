# frozen_string_literal: true

require_relative '../../routing/parser'
require_relative '../v3/openapi_object'
require_relative '../base'
require_relative '../squeezer'
require_relative '../../shared/all'
require_relative '../manager/file/path_item_file_manager'

module RoutesToSwaggerDocs
  module Schema
    class BaseGenerator < Base
      include Sortable

      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @glob_schema_paths = create_glob_schema_paths
      end

      private

      attr_accessor :unit_paths_file_path
      attr_accessor :skip_generate_schemas
      attr_accessor :skip_load_dot_paths

      # Scope Rails
      def create_docs
        all_routes = create_all_routes
        parser = Routing::Parser.new(all_routes)

        routes_data = parser.routes_data
        tags_data = parser.tags_data
        schemas_data = parser.schemas_data

        Schema::V3::OpenapiObject.new(routes_data, tags_data, schemas_data).to_doc
      end

      def create_all_routes
        ::Rails.application.reload_routes!
        ::Rails.application.routes.routes
      end

      def schema_file_do_not_exists?
        schema_files_paths.count == 0
      end

      def create_glob_schema_paths
        if many_paths_file_paths.present? && !skip_load_dot_paths
          exclude_paths_regexp_paths = "#{schema_save_dir_path}/**.yml"
          [exclude_paths_regexp_paths] + many_paths_file_paths + components_file_paths
        else
          ["#{schema_save_dir_path}/**/**.yml"]
        end
      end

      def schema_files_paths
        Dir.glob(@glob_schema_paths)
      end

      def many_paths_file_paths
        case
        when unit_paths_file_path.present? && !skip_load_dot_paths
          [unit_paths_file_path]
        when !unit_paths_file_path.present? && !skip_load_dot_paths
          paths_config.many_paths_file_paths
        else
          Dir.glob("#{schema_save_dir_path}/paths/**/**.yml")
        end
      end

      def components_file_paths
        many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
          file_manager = PathItemFileManager.new(unit_paths_path, :full)
          components_file_paths_at_path = file_manager.descendants_ref_paths
          result.push(*components_file_paths_at_path)
        end.uniq
      end
    end
  end
end
