# frozen_string_literal: true

require_relative 'base_analyzer'
require_relative 'components/schemas_analyzer'
require_relative 'components/request_bodies_analyzer'
require_relative 'components/security_schemes_analyzer'
require_relative 'components/parameters_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class ComponentsAnalyzer < BaseAnalyzer
      def initialize(before_schema_data, after_schema_data, options = {})
        super
        @components_schemas_analyzer          = Components::SchemasAnalyzer.new(before_schema_data, after_schema_data, options)
        @components_request_bodies_analyzer   = Components::RequestBodiesAnalyzer.new(before_schema_data, after_schema_data, options)
        @components_security_schemas_analyzer = Components::SecuritySchemesAnalyzer.new(before_schema_data, after_schema_data, options)
        @components_parameters_analyzer       = Components::ParametersAnalyzer.new(before_schema_data, after_schema_data, options)
      end

      def analyze_docs
        logger.info '[Analyze Swagger file (components/schemas)] start'
        @components_schemas_analyzer.analyze_docs
        logger.info '[Analyze Swagger file (components/schemas)] end'

        logger.info '[Analyze Swagger file (components/requestBodies)] start'
        @components_request_bodies_analyzer.analyze_docs
        logger.info '[Analyze Swagger file (components/requestBodies)] end'

        logger.info '[Analyze Swagger file (components/securitySchemas)] start'
        @components_security_schemas_analyzer.analyze_docs
        logger.info '[Analyze Swagger file (components/securitySchemas)] end'

        logger.info '[Analyze Swagger file (components/parameters)] start'
        @components_parameters_analyzer.analyze_docs
        logger.info '[Analyze Swagger file (components/parameters)] end'
      end
    end
  end
end
