# frozen_string_literal: true

require_relative 'base_generator'
require_relative 'components/schema_generator'
require_relative 'components/request_body_generator'
require_relative 'components/security_scheme_generator'
require_relative 'components/parameter_generator'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(options)
        @components = schema_data['components'] || scehma_data[:components]
        @options = options
      end

      def generate_docs
        @components.each do |key, _value|
          case key
          when 'schemas'
            Components::SchemaGenerator.new(@components, @options).generate_docs
          when 'requestBodies'
            Components::RequestBodyGenerator.new(@components, @options).generate_docs
          when 'securitySchemes'
            Components::SecuritySchemeGenerator.new(@components, @options).generate_docs
          when 'parameters'
            Components::ParameterGenerator.new(@components, @options).generate_docs
          else
            raise "Do not support components object: #{key}"
          end
        end
      end
    end
  end
end
