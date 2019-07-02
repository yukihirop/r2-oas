# frozen_string_literal: true

require_relative 'base_generator'
require_relative 'components/schema_generator'
require_relative 'components/request_body_generator'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(options)
        @components = schema_data['components'] || scehma_data[:components]
        @options = options
      end

      def generate_components
        @components.each do |key, _value|
          if key == 'schemas'
            Components::SchemaGenerator.new(@components, @options).generate_components_schemas
          elsif key == 'requestBodies'
            Components::RequestBodyGenerator.new(@components, @options).generate_components_request_bodies
          end
        end
      end
    end
  end
end
