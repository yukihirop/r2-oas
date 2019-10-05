# frozen_string_literal: true

require_relative '../include_ref_base_file_manager'
require_relative '../components_file_manager'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodyFileManager < IncludeRefBaseFileManager
        def initialize(path, path_type = :ref)
          super
          @recursive_search_class = ComponentsFileManager
        end

        def skip_save?
          save_file_path.in? paths_config.many_components_file_paths
        end
      end
    end
  end
end
