require_relative 'base_generator'
require_relative 'components/schema_generator'
require_relative 'components/request_body_generator'

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
            options = { components_file_paths: components_file_paths }
            Components::SchemaGenerator.new(@components, options).generate_components_schemas
          elsif key == "requestBodies"
            options = { components_file_paths: components_file_paths }
            Components::RequestBodyGenerator.new(@components, options).generate_components_request_bodies
          end
        end
      end
    end
  end
end