require 'fileutils'
require_relative 'base_generator'
require_relative 'path_generator'
require_relative 'components_generator'

module RoutesToSwaggerDocs
  module Schema
    class SchemaGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @docs = create_docs
      end

      def generate_schemas
        if force_update_schema || schema_file_do_not_exists?
          logger.info "<From routes data>"
          generate_schemas_from_routes_data
        else
          logger.info "<From schema files>"
          generate_schemas_from_schema_fiels
        end
      end
      
      private
      
      def generate_schemas_from_schema_fiels
        schemas_from_schema_fiels = schema_files_paths.each_with_object({}) do |path, data|
          yaml = YAML.load_file(path)
          data.deep_merge!(yaml)
          logger.info " Fetch schema file: \t#{path}"
        end
        @docs.deep_merge!(schemas_from_schema_fiels)
        process_when_generate_schemas(schema_override: true)
      end
      
      def generate_schemas_from_routes_data
        process_when_generate_schemas
      end
      
      def process_when_generate_schemas(schema_override: false)
        logger.info "<Update schema files>"
        @docs.each do |field_name, data|
          result = { "#{field_name}" => data }
          options = { unit_paths_file_path: unit_paths_file_path }

          case field_name
          when "paths"
            logger.info " [Generate Swagger schema files (paths)] start"
            PathGenerator.new(result, options).generate_paths
            logger.info " [Generate Swagger schema files (paths)] end"
          when "components"
            logger.info " [Generate Swagger schema files (components)] start"
            ComponentsGenerator.new(result, options).generate_components
            logger.info " [Generate Swagger schema files (components)] end"
          else
            filename_with_namespace = field_name
            save_path = save_path_for(filename_with_namespace)
            File.write(save_path, result.to_yaml)

            if schema_override
              logger.info " Merge schema file: \t#{save_path}"
            else
              logger.info " Write schema file: \t#{save_path}"
            end
          end
        end
      end
    end
  end
end
