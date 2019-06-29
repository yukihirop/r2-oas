# frozen_string_literal: true

require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemaSqueezer < BaseSqueezer
        def initialize(schema_data = {}, _options = {})
          @schema_data = schema_data
        end

        def remake_components_schemas
          { 'schemas' => @schema_data['components']['schemas'] }
        end
      end
    end
  end
end
