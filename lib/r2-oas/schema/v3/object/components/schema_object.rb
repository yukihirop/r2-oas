# frozen_string_literal: true

require 'r2-oas/dynamic/schema/v3/object/hookable_base_object'

module R2OAS
  module Schema
    module V3
      module Components
        class SchemaObject < R2OAS::Plugins::Schema::V3::HookableBaseObject
          def initialize(route_data, path)
            super()
            @path_comp    = Routing::PathComponent.new(path)
            @path         = @path_comp.symbol_to_brace
            @route_data   = route_data
            @verb         = route_data[:verb]
            @tag_name     = route_data[:tag_name]
            @schema_name  = route_data[:schema_name]
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

          # MEMO:
          # please override in inherited class.
          def components_schema_name(_doc, _path_component, _tag_name, _verb, _http_status, schema_name)
            schema_name
          end

          private

          def _components_schema_name(http_status)
            components_schema_name(doc, @path_comp, @tag_name, @verb, http_status, @schema_name)
          end
        end
      end
    end
  end
end
