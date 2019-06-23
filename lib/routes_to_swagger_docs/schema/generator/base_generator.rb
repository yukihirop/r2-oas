require_relative '../../routing/parser'
require_relative '../v3/openapi_object'
require_relative '../base'
require_relative '../squeezer'
require_relative '../../shared/all'

module RoutesToSwaggerDocs
  module Schema
    class BaseGenerator < Base
      include Searchable
      include Sortable
      include Writable

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
        when skip_load_dot_paths
          Dir.glob("#{schema_save_dir_path}/paths/**/**.yml")
        else
          paths_config.many_paths_file_paths
        end
      end

      def components_file_paths
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
          result.push(File.expand_path(component_path))
        end
      end

      def deep_search_component_file_recursive(yaml, target, &block)
        if yaml.is_a?(Hash)
          yaml.each do |key, value|
            process_deep_search_component_file_recursive(key, value, target, &block)
          end
        # Support allOf/oneOf/anyOf 
        elsif yaml.is_a?(Array)
          yaml.each do |el|
            if el.is_a?(Hash)
              el.each do |key, value|
                process_deep_search_component_file_recursive(key, value, target, &block)
              end
            end
          end
        end
      end

      def process_deep_search_component_file_recursive(key, value, target, &block)
        component_info = value

        if key.eql? target
          relative_component_path_data = component_info.gsub("#/","").split("/")
          relative_component_path = relative_component_path_data.each.with_index.inject("") do |base,(value, index)|
            if index == relative_component_path_data.size - 1
              value = value.to_s.gsub("_", "/").underscore
            end
            "#{base}/#{value}"
          end

          component_path = "#{schema_save_dir_path}#{relative_component_path}.yml"
          component_data = YAML.load_file(component_path)

          children_components_paths = []
          deep_search_component_file_recursive(component_data, target) do |children_components_path|
            children_components_paths.push(*children_components_path)
          end

          components_paths = [ component_path ] + children_components_paths
          yield components_paths if block_given?
        else
          deep_search_component_file_recursive(component_info, target, &block)
        end
      end
    end
  end
end
