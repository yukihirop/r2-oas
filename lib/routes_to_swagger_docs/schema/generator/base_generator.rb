require_relative '../../routing/parser'
require_relative '../v3/openapi_object'
require_relative '../base'
require_relative '../squeezer'
require_relative '../../shared/searchable'

module RoutesToSwaggerDocs
  module Schema
    class BaseGenerator < Base
      include RoutesToSwaggerDocs::Searchable

      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @glob_schema_paths = create_glob_schema_paths
      end
      
      private
      
      attr_accessor :unit_paths_file_path
      attr_accessor :skip_generate_schemas
      
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
        if unit_paths_file_path.present?
          exclude_paths_regexp_paths = "#{schema_save_dir_path}/**.yml"
          [unit_paths_file_path, exclude_paths_regexp_paths] + components_file_paths
        else
          ["#{schema_save_dir_path}/**/**.yml"]
        end
      end
      
      def schema_files_paths
        Dir.glob(@glob_schema_paths)
      end

      def components_file_paths
        return nil if unit_paths_file_path.blank?
        yaml = YAML.load_file(unit_paths_file_path)
        
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
          yaml.keys.each do |key|
            if key.eql? target
              component_info = yaml[key]
              relative_component_path = component_info.gsub("#/","")
              component_path = "#{schema_save_dir_path}/#{relative_component_path}.yml"
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
