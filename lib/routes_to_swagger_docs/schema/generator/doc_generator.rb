require 'yaml'
require 'fileutils'
require_relative 'base_generator'
require_relative 'schema_generator'
require_relative '../squeezer'

module RoutesToSwaggerDocs
  module Schema
    class DocGenerator < BaseGenerator
      attr_accessor :swagger_doc

      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @schema_generator = SchemaGenerator.new(schema_data, options)
      end
      
      def generate_docs
        logger.info "[Generate Swagger schema files] start"
        @schema_generator.generate_schemas unless skip_generate_schemas
        logger.info "[Generate Swagger schema files] end"
        logger.info "[Generate Swagger docs from schema files] start"
        generate_docs_from_schema_files
        logger.info "[Generate Swagger docs from schema files] end"
      end
      
      private
      
      def generate_docs_from_schema_files
        result_before_squeeze = schema_files_paths.each_with_object({}) do |path, data|
          yaml = YAML.load_file(path)
          data.deep_merge!(yaml)
          logger.info " Use schema file: \t#{path}"
        end

        if many_paths_file_paths.present?
          result = Squeezer.new(result_before_squeeze, many_paths_file_paths: many_paths_file_paths).remake_docs
        else
          result = result_before_squeeze
        end

        @swagger_doc = result
        File.write(doc_save_file_path, result.to_yaml)
      end
    end
  end
end
