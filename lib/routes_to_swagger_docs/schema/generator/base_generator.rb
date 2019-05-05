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
      
      def logger
        ::Rails.logger
      end
      
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
          [unit_paths_file_path, exclude_paths_regexp_paths] + components_schemas_file_paths
        else
          ["#{schema_save_dir_path}/**/**.yml"]
        end
      end
      
      def schema_files_paths
        Dir.glob(@glob_schema_paths)
      end

      def components_schemas_file_paths
        return nil if unit_paths_file_path.blank?
        yaml = YAML.load_file(unit_paths_file_path)
        
        schema_paths = []
        deep_search(yaml, "$ref") do |result|
          schema_paths.push(result)
        end

        schema_data = schema_paths.uniq.map{ |schema_path| schema_path.split("/").last }
        schema_data.each_with_object([]) do |schema_datum, result|
          schema_name_with_namespace = schema_datum.gsub("_", "/").downcase
          unit_schema_path = "#{schema_save_dir_path}/components/schemas/#{schema_name_with_namespace}.yml"
          result.push(File.expand_path(unit_schema_path))
        end
      end
    end
  end
end
