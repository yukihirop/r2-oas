# frozen_string_literal: true

require_relative 'include_ref_base_file_manager'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsFileManager < IncludeRefBaseFileManager
      def initialize(path, path_type = :ref)
        super
        @path_type = path_type
        @original_path = path
        @recursive_search_class = self.class
      end

      def skip_save?
        save_file_path.in? paths_config.many_components_file_paths
      end
    end
  end
end
