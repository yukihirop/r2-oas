require_relative './base_analyzer'
require_relative 'components/schemas_analyzer'
require_relative 'components/request_bodies_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class ComponentsAnalyzer < BaseAnalyzer
      def initialize(before_schema_data, after_schema_data, options = {})
        super
        @components_schemas_analyzer        = Components::SchemasAnalyzer.new(before_schema_data, after_schema_data, options)
        @components_request_bodies_analyzer = Components::RequestBodiesAnalyzer.new(before_schema_data, after_schema_data, options)
      end

      def update_from_schema
        edited_components_schema = @after_schema_data["components"]
        edited_components_schema.each do |component_type, _|
          case component_type
          when "schemas"
            logger.info "[Analyze Swagger file (components/schemas)] start"
            @components_schemas_analyzer.update_from_schema
            logger.info "[Analyze Swagger file (components/schemas)] end"
          when "requestBodies"
            logger.info "[Analyze Swagger file (components/requestBodies)] start"
            @components_request_bodies_analyzer.update_from_schema
            logger.info "[Analyze Swagger file (components/requestBodies)] end"
          end
        end
      end
    end
  end
end