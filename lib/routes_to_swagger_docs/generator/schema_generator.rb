require 'fileutils'
require_relative 'base_generator'
require_relative 'path_generator'

module RoutesToSwaggerDocs
  class SchemaGenerator < BaseGenerator
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
      schemas_from_schema_fiels = Dir.glob(schema_paths).each_with_object({}) do |path, data|
        yaml = YAML.load_file(path)
        data.deep_merge!(yaml)
        logger.info " Fetch schema file: \t#{path}"
      end
      docs.deep_merge!(schemas_from_schema_fiels)
      process_when_generate_schemas(schema_override: true)
    end

    def generate_schemas_from_routes_data
      FileUtils.mkdir_p(schema_save_dir_path) unless FileTest.exists?(schema_save_dir_path)
      process_when_generate_schemas
    end

    def process_when_generate_schemas(schema_override: false)
      logger.info "<Update schema files>"
      docs.each do |field_name, data|
        result = { "#{field_name}" => data }

        if field_name == "paths"
          logger.info " [Generate Swagger schema files (paths)] start"
          PathGenerator.new(result).generate_paths
          logger.info " [Generate Swagger schema files (paths)] end"
        else
          write_path = File.expand_path("#{schema_save_dir_path}/#{field_name}.yml", "./")
          File.write(write_path, result.to_yaml)
          if schema_override
            logger.info " Merge schema file: \t#{write_path}"
          else
            logger.info " Write schema file: \t#{write_path}"
          end
        end
      end
    end
  end
end
