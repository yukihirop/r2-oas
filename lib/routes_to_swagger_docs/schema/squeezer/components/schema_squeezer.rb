require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemaSqueezer < BaseSqueezer
        def remake_components_schemas
          { "schemas" => @schema_data["components"]["schemas"] }
        end
      end
    end
  end
end