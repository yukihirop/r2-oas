# frozen_string_literal: true

require_relative 'base_squeezer'
require_relative 'components/schema_squeezer'
require_relative 'components/request_body_squeezer'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsSqueezer < BaseSqueezer
      def initialize(schema_data, options = {})
        super
        @schema_squeezer       = Components::SchemaSqueezer.new(schema_data, options)
        @request_body_squeezer = Components::RequestBodySqueezer.new(schema_data, options)
      end

      def remake_components
        slice_components_schema = @schema_data['components'].keys.each_with_object({}) do |key, result|
          if key == 'schemas'
            data = @schema_squeezer.remake_components_schemas
            result.deep_merge!(data)
          elsif key == 'requestBodies'
            data = @request_body_squeezer.remake_components_request_bodies
            result.deep_merge!(data)
          end
        end
        { 'components' => slice_components_schema }
      end
    end
  end
end
