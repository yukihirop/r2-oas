require 'yaml'
require 'fileutils'
require_relative 'base_generator'
require_relative 'schema_generator'

module RoutesToSwaggerDocs
  class DocGenerator < BaseGenerator
    def generate_docs
      logger.info "[Generate Swagger schema files] start"
      generate_schemas
      logger.info "[Generate Swagger schema files] end"
      logger.info "[Generate Swagger docs from schema files] start"
      generate_docs_from_schema_files
      logger.info "[Generate Swagger docs from schema files] end"
    end

    private

    def generate_schemas
      SchemaGenerator.new.generate_schemas
    end

    def generate_docs_from_schema_files
      result = Dir.glob(schema_paths).each_with_object({}) do |path, data|
        yaml = YAML.load_file(path)
        data.deep_merge!(yaml)
        logger.info " Use schema file: \t#{path}"
      end
      File.write(doc_save_file_path, result.to_yaml)
    end
  end
end
