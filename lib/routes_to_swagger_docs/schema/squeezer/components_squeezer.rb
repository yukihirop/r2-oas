# frozen_string_literal: true

require_relative 'base_squeezer'
require_relative 'components/schema_squeezer'
require_relative 'components/request_body_squeezer'
require_relative 'components/security_scheme_squeezer'
require_relative 'components/parameter_squeezer'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsSqueezer < BaseSqueezer
      def initialize(schema_data, options = {})
        super
        @schema_squeezer          = Components::SchemaSqueezer.new(schema_data, options)
        @request_body_squeezer    = Components::RequestBodySqueezer.new(schema_data, options)
        @security_scheme_squeezer = Components::SecuritySchemeSqueezer.new(schema_data, options)
        @parameter_squeezer       = Components::ParameterSqueezer.new(schema_data, options)
      end

      def squeeze_docs
        slice_components_schema = @schema_data['components'].keys.each_with_object({}) do |key, result|
          case key
          when 'schemas'
            data = @schema_squeezer.squeeze_docs
            result.deep_merge!(data)
          when 'requestBodies'
            data = @request_body_squeezer.squeeze_docs
            result.deep_merge!(data)
          when 'securitySchemes'
            data = @security_scheme_squeezer.squeeze_docs
            result.deep_merge!(data)
          when 'parameters'
            data = @parameter_squeezer.squeeze_docs
            result.deep_merge!(data)
          else
            raise "Do not support components object: #{key}"
          end
        end
        { 'components' => slice_components_schema }
      end
    end
  end
end
