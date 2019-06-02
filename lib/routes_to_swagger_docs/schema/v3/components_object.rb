require_relative '../../plugins/schema/v3/hookable_base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ComponentsObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        def initialize(schemas_data)
          super(schemas_data)
          @schemas_data = schemas_data
        end

        def create_doc
          result = @schemas_data.each_with_object({}) do |schema_name, docs|
            docs[schema_name] = schema_object_class.new.to_doc
          end.tap { |schema| break { "schemas" => schema } }
          doc.merge!(result)
        end
      end
    end
  end
end