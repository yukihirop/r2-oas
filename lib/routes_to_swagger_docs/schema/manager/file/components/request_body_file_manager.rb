require_relative '../include_ref_base_file_manager'
require_relative '../components_file_manager'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodyFileManager < IncludeRefBaseFileManager
        def skip_save?
          save_file_path.in? paths_config.many_components_file_paths
        end
        
        private

        def process_deep_search_ref_recursive(ref_key_or_not, ref_value_or_not, &block)
          if ref_key_or_not.eql? REF
            child_file_manager = ComponentsFileManager.build(ref_value_or_not, :ref)
            child_load_data = child_file_manager.load_data

            children_paths = []
            deep_search_ref_recursive(child_load_data) do |children_path|
              children_paths.push(*children_path)
            end

            results = [ child_file_manager.save_file_path ] + children_paths
            yield results if block_given?
          else
            deep_search_ref_recursive(ref_value_or_not, &block)
          end
        end
      end
    end
  end
end