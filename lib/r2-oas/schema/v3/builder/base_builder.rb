# frozen_string_literal: true

require 'r2-oas/schema/v3/base'
require 'r2-oas/routing/parser'
require 'r2-oas/schema/v3/object/from_routes/openapi_object'
require 'r2-oas/schema/v3/manager/file/path_item_file_manager'

module R2OAS
  module Schema
    module V3
      class BaseBuilder < Base
        include Sortable

        def initialize(opts = {})
          super

          opts.keys.each do |key|
            send("#{key}=", opts[key])
          end

          @opts = opts
          @glob_schema_paths = create_glob_schema_paths
        end

        private

        attr_accessor :unit_paths_file_path
        attr_accessor :skip_load_dot_paths
        attr_accessor :opts
        attr_accessor :use_plugin
        attr_accessor :output

        alias use_plugin? use_plugin
        alias output? output

        def schema_file_do_not_exists?
          schema_files_paths.count == 0
        end

        def create_glob_schema_paths
          exclude_paths_regexp_paths               = ["#{schema_save_dir_path}/**.yml"]
          components_security_schemes_regexp_paths = ["#{schema_save_dir_path}/components/securitySchemes/**/**.yml"]

          # components/securitySchemes is not referenced in $ ref.
          exclude_paths_regexp_paths + many_paths_file_paths + many_components_file_paths + components_security_schemes_regexp_paths
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
      end
    end
  end
end
