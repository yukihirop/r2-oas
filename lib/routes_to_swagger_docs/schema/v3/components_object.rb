require_relative 'base_object'
require_relative 'schema_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ComponentsObject < BaseObject
        def initialize(schemas_data)
          @schemas_data = schemas_data
        end

        def to_doc
          @schemas_data.each_with_object({}) do |schema_name, docs|
            docs[schema_name] = SchemaObject.new.to_doc
          end.tap { |schema| break { "schemas" => schema } }
        end
      end
    end
  end
end