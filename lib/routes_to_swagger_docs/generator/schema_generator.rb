require 'fileutils'
require_relative 'base_generator'
require_relative 'path_generator'

module RoutesToSwaggerDocs
  class SchemaGenerator < BaseGenerator
    def generate_schemas
      if force_update_schema || schema_file_do_not_exists?
        generate_schemas_from_routes_data
      else
        generate_schemas_from_schema_fiels
      end
    end

    private

    def generate_schemas_from_schema_fiels
      schemas_from_schema_fiels = Dir.glob(schema_paths).each_with_object({}) do |path, data|
        yaml = YAML.load_file(path)
        data.deep_merge!(yaml)
      end
      docs.deep_merge!(schemas_from_schema_fiels)
      process_when_generate_schemas
    end

    def generate_schemas_from_routes_data
      FileUtils.mkdir_p(schema_save_dir_path) unless FileTest.exists?(schema_save_dir_path)
      process_when_generate_schemas
    end

    def process_when_generate_schemas
      docs.each do |field_name, data|
        result = { "#{field_name}" => data }

        if field_name == "paths"
          PathGenerator.new(result).generate_paths
        else
          File.write("#{schema_save_dir_path}/#{field_name}.yml", result.to_yaml)
        end
      end
    end
  end
end
