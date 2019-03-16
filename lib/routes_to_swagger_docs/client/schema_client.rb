require 'fileutils'
require_relative 'base_client'
require_relative 'path_client'

module RoutesToSwaggerDocs
  class SchemaClient < BaseClient
    def generate_schemas
      if force_update_schema || schema_file_do_not_exists?
        generate_schemas_from_routes_data
      end
    end

    private

    def generate_schemas_from_routes_data
      FileUtils.mkdir_p(schema_save_dir_path) unless FileTest.exists?(schema_save_dir_path)
      docs.each do |field_name, data|
        result = { "#{field_name}" => data }

        if field_name == "paths"
          PathClient.new(result).generate_paths
        else
          File.write("#{schema_save_dir_path}/#{field_name}.yml", result.to_yaml)
        end
      end
    end
  end
end
