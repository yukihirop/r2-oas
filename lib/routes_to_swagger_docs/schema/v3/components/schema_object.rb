require_relative '../schema_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      module Components
        class SchemaObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject

          def initialize(schema_name)
            super()
            @schema_name = schema_name
          end

          def to_doc
            schema_object_class.new(@schema_name).to_doc
          end
        end
      end
    end
  end
end
