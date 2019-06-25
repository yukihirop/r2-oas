require_relative '../include_ref_base_file_manager'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemaFileManager < IncludeRefBaseFileManager
        def skip_save?
          save_file_path.in? paths_config.many_components_file_paths
        end
      end
    end
  end
end