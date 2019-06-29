# frozen_string_literal: true

require_relative '../../plugins/schema/v3/hookable_base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class SchemaObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        def initialize(schema_name)
          super({})
          @schema_name = schema_name
        end

        def to_doc
          execute_before_create(@schema_name)
          create_doc
          execute_after_create(@schema_name)
          doc
        end

        def create_doc
          result = {
            'type' => 'object',
            'properties' => {
              'id' => {
                'type' => 'integer',
                'format' => 'int64'
              }
            }
          }
          doc.merge!(result)
        end
      end
    end
  end
end
