# frozen_string_literal: true

require 'r2-oas/schema/v3/base'
require 'r2-oas/routing/parser'
require 'r2-oas/schema/v3/object/from_routes/openapi_object'
require 'r2-oas/schema/v3/manager/file/path_item_file_manager'
require 'r2-oas/store'

module R2OAS
  module Schema
    module V3
      class BaseGenerator < Base
        include Sortable

        def initialize(options = {})
          super

          options.keys.each do |key|
            send("#{key}=", options[key])
          end

          @store = Store.create
          @glob_schema_paths = create_glob_schema_paths
        end

        private

        attr_accessor :unit_paths_file_path
        attr_accessor :skip_load_dot_paths
        attr_accessor :is_create_cache
        attr_accessor :store
        attr_accessor :use_plugin

        alias use_plugin? use_plugin

        # Scope Rails
        def create_docs
          all_routes = create_all_routes
          parser = Routing::Parser.new(all_routes)

          routes_data = parser.routes_data
          tags_data = parser.tags_data
          schemas_data = parser.schemas_data

          Schema::V3::OpenapiObject.new(routes_data, tags_data, schemas_data, { use_plugin: use_plugin }).to_doc
        end

        def create_all_routes
          ::Rails.application.reload_routes!
          ::Rails.application.routes.routes
        end

        def schema_file_do_not_exists?
          schema_files_paths.count == 0
        end

        def create_glob_schema_paths
          exclude_paths_regexp_paths               = ["#{schema_save_dir_path}/**.yml"]
          paths_regexp_paths                       = ["#{schema_save_dir_path}/paths/**/**.yml"]
          components_schemas_regexp_paths          = ["#{schema_save_dir_path}/components/**/**.yml"]
          components_security_schemes_regexp_paths = ["#{schema_save_dir_path}/components/securitySchemes/**/**.yml"]

          if exists_paths_files?
            # components/securitySchemes is not referenced in $ ref.
            exclude_paths_regexp_paths + many_paths_file_paths + many_components_file_paths + components_security_schemes_regexp_paths
          else
            exclude_paths_regexp_paths + paths_regexp_paths + components_schemas_regexp_paths
          end
        end

        def schema_files_paths
          Dir.glob(@glob_schema_paths)
        end

        def many_paths_file_paths
          if unit_paths_file_path.present? && !skip_load_dot_paths
            [unit_paths_file_path]
          elsif !unit_paths_file_path.present? && !skip_load_dot_paths && paths_config.all_load_paths?
            paths_config.many_paths_file_paths
          else
            Dir.glob("#{schema_save_dir_path}/paths/**/**.yml")
          end
        end

        def many_components_file_paths
          @many_components_file_paths ||= many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
            file_manager = PathItemFileManager.new(unit_paths_path, :full)
            components_file_paths_at_path = file_manager.descendants_ref_paths
            result.push(*components_file_paths_at_path)
          end.uniq
        end

        def exists_paths_files?
          Dir.glob("#{schema_save_dir_path}/paths/**/**.yml").present?
        end

        def cache_docs
          if exists_cache?
            result = IO.binread(abs_cache_docs_path)
            inflate = Zlib::Inflate.inflate(result)
            @cache_docs ||= Marshal.load(inflate)
          else
            @cache_docs ||= {}
          end
        end

        def exists_cache?
          FileTest.exists?(abs_cache_docs_path)
        end

        def abs_cache_docs_path
          File.expand_path(relative_cahe_docs_path)
        end

        def relative_cahe_docs_path
          "#{@root_dir_path}/.docs"
        end

        def unknown_paths_path
          "#{@root_dir_path}/src/paths/unknown.yml"
        end
      end
    end
  end
end
