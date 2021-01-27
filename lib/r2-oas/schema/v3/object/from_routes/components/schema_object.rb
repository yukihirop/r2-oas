# frozen_string_literal: true

require 'r2-oas/schema/v3/object/from_routes/base_object'

module R2OAS
  module Schema
    module V3
      module Components
        class SchemaObject < R2OAS::Schema::V3::BaseObject
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
            create_doc
            doc
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
            @schema_name
          end
        end
      end
    end
  end
end
