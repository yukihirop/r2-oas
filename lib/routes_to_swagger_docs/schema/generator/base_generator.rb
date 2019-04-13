require_relative '../../routing/parser'
require_relative '../v3/openapi_object'
require_relative '../base'
require_relative '../squeezer'

module RoutesToSwaggerDocs
  module Schema
    class BaseGenerator < Base
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        
        @all_routes = create_all_routes
        @docs = create_docs
        @glob_schema_paths = create_glob_schema_paths
      end
      
      private
      
      attr_accessor :unit_paths_file_path
      
      def logger
        ::Rails.logger
      end
      
      def create_all_routes
        ::Rails.application.reload_routes!
        ::Rails.application.routes.routes
      end
      
      # Scope Rails
      def create_docs
        routes_data = parser.routes_data
        tags_data = parser.tags_data
        schemas_data = parser.schemas_data
        
        Schema::V3::OpenapiObject.new(routes_data, tags_data, schemas_data).to_doc
      end
      
      def parser
        @parser ||= Routing::Parser.new(@all_routes)
      end
      
      def schema_file_do_not_exists?
        schema_files_paths.count == 0
      end
      
      def create_glob_schema_paths
        if unit_paths_file_path.present?
          exclude_paths_regexp_paths = "#{schema_save_dir_path}/**.yml"
          [unit_paths_file_path, exclude_paths_regexp_paths]
        else
          ["#{schema_save_dir_path}/**/**.yml"]
        end
      end
      
      def schema_files_paths
        Dir.glob(@glob_schema_paths)
      end
    end
  end
end
