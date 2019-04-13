require_relative 'base_object'


module RoutesToSwaggerDocs
  module Schema
    module V3
      class SchemaObject < BaseObject
        def to_doc
          {
            "type" => "object",
            "properties" => {
              "id" => {
                "type" => "integer",
                "format" => "int64"
              }
            } 
          }
        end
      end
    end
  end
end