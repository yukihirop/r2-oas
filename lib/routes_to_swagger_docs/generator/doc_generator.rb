require 'yaml'
require 'fileutils'
require_relative 'base_client'
require_relative 'schema_client'

module RoutesToSwaggerDocs
  class DocGenerator < BaseGenerator
    def generate_docs
      generate_schemas
      generate_docs_from_schema_files
    end

    private

    def generate_schemas
      SchemaGenerator.new.generate_schemas
    end

    def generate_docs_from_schema_files
      result = Dir.glob(schema_paths).each_with_object({}) do |path, data|
        yaml = YAML.load_file(path)
        data.deep_merge!(yaml)
      end
      File.write(doc_save_file_path, result.to_yaml)
    end
  end
end
