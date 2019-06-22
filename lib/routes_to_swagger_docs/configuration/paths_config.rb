module RoutesToSwaggerDocs
  module Configuration
    class PathsConfig
      def initialize(root_dir_path, schema_save_dir_name)
        @root_dir_path = root_dir_path
        @schema_save_dir_path = "#{root_dir_path}/#{schema_save_dir_name}"
      end

      def abs_paths_path
        File.expand_path("#{@root_dir_path}/.paths")
      end

      def many_paths_file_paths
        File.read(abs_paths_path).split("\n").each_with_object([]) do |relative_path, result|
          abs_path = File.expand_path("#{@schema_save_dir_path}/paths/#{relative_path}")
          result.push(abs_path) if FileTest.exists?(abs_path) && FileTest.file?(abs_path)
        end.uniq.compact.reject(&:empty?)
      end

      def create_dot_paths
        abs_root_path = File.expand_path(@root_dir_path)

        FileUtils.mkdir_p(abs_root_path) unless FileTest.exists?(abs_root_path)
        File.write(abs_paths_path, "") unless FileTest.exists?(abs_paths_path)
      end

      def many_components_file_paths
        many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
          components_file_paths_at_path = components_file_paths_for_path(unit_paths_path)
          result.push(*components_file_paths_at_path)
        end.uniq
      end

      def components_file_paths_for_path(path)
        yaml = YAML.load_file(path)
        
        components_paths = []
        deep_search_component_file_recursive(yaml, "$ref") do |component_paths|
          components_paths.push(*component_paths)
        end

        components_paths = components_paths.uniq
        components_paths.each_with_object([]) do |component_path, result|
          abs_component_path = File.expand_path(component_path)
          result.push(abs_component_path) if FileTest.exists?(abs_component_path)
        end
      end

      def deep_search_component_file_recursive(yaml, target, &block)
        if yaml.is_a?(Hash)
          yaml.keys.each do |key|
            if key.eql? target
              component_info = yaml[key]
              
              relative_component_path_data = component_info.gsub("#/","").split("/")
              relative_component_path = relative_component_path_data.each.with_index.inject("") do |base,(value, index)|
                if index == relative_component_path_data.size - 1
                  value = value.to_s.gsub("_", "/").underscore
                end
                "#{base}/#{value}"
              end

              component_path = "#{@schema_save_dir_path}#{relative_component_path}.yml"
              component_data = YAML.load_file(component_path)

              children_components_paths = []
              deep_search_component_file_recursive(component_data, target) do |children_components_path|
                children_components_paths.push(*children_components_path)
              end

              components_paths = [ component_path ] + children_components_paths
              yield components_paths if block_given?
            else
              deep_search_component_file_recursive(yaml[key], target, &block)
            end
          end
        end
      end
    end
  end
end
