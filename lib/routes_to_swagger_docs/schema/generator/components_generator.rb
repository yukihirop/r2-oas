require_relative 'base_generator'
require_relative 'components/schema_generator'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @components = schema_data["components"] || scehma_data[:components]
      end

      def generate_components
        @components.each do |key, value|
          if key == "schemas"
            options = { unit_components_schemas_file_path: unit_components_schemas_file_path }
            Components::SchemaGenerator.new(@components, options).generate_components_schemas
          end
        end
      end

      private

      def unit_components_schemas_file_path
        paths_path = "#{schema_save_dir_path}/paths"
        components_schemas_path = "#{schema_save_dir_path}/components/schemas"
        abs_unit_paths_file_path = File.expand_path(unit_paths_file_path)
        abs_unit_paths_file_path.gsub(paths_path, components_schemas_path)
      end
    end
  end
end