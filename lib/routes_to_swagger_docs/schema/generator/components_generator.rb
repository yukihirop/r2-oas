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
    end
  end
end