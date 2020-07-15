# frozen_string_literal: true

require 'r2-oas/dynamic/schema/v3/object/from_routes/hookable_base_object'

module R2OAS
  module Schema
    module V3
      module Components
        class SchemaObject < R2OAS::Dynamic::Schema::V3::HookableBaseObject
          def initialize(route_data, path, opts = {})
            super(opts)
            @path_comp    = Routing::PathComponent.new(path)
            @path         = @path_comp.symbol_to_brace
            @route_data   = route_data
            @verb         = route_data[:verb]
            @tag_name     = route_data[:tag_name]
            @schema_name  = route_data[:schema_name]
            # MEMO:
            # Allow primitive types that cannot be passed by reference to be passed by reference
            # This is Compromise
            @ref          = { schema_name: @schema_name, tag_name: @tag_name, verb: @verb }
          end

          def to_doc
            execute_before_create(@schema_name)
            create_doc
            execute_after_create(@schema_name)
            execute_transform_plugins(:components_schema, doc, @path_comp, @ref)
            doc
          end

          # MEMO:
          # please override in inherited class.
          def components_schema_name(_doc, _path_component, _tag_name, _verb, _http_status, schema_name)
            schema_name
          end

          private

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

          def _components_schema_name(http_status)
            @ref[:schema_name] = components_schema_name(doc, @path_comp, @tag_name, @verb, http_status, @schema_name)
            @ref[:http_status] = http_status
            execute_transform_plugins(:components_schema_name, @path_comp, @ref)
            @ref[:schema_name]
          end
        end
      end
    end
  end
end
