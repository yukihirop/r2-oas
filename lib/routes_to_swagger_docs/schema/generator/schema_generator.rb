require 'fileutils'
require_relative 'base_generator'
require_relative 'path_generator'
require_relative 'components_generator'
require_relative '../manager/file_manager'

module RoutesToSwaggerDocs
  module Schema
    class SchemaGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @docs = create_docs
        @options = options
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
        process_when_generate_schemas do |save_file_path|
          logger.info " Merge schema file: \t#{save_file_path}"
        end
      end
      
      def generate_schemas_from_routes_data
        process_when_generate_schemas do |save_file_path|
          logger.info " Write schema file: \t#{save_file_path}"
        end
      end
      
      def process_when_generate_schemas(schema_override: false)
        logger.info "<Update schema files>"
        @docs.each do |field_name, data|
          result = { "#{field_name}" => data }

          case field_name
          when "paths"
            logger.info " [Generate Swagger schema files (paths)] start"
            PathGenerator.new(result, @options).generate_paths
            logger.info " [Generate Swagger schema files (paths)] end"
          when "components"
            logger.info " [Generate Swagger schema files (components)] start"
            ComponentsGenerator.new(result, @options).generate_components
            logger.info " [Generate Swagger schema files (components)] end"
          else
            file_manager = FileManager.new(field_name, :relative)
            file_manager.save(result.to_yaml)

            yield file_manager.save_file_path if block_given?
          end
        end
      end
    end
  end
end
