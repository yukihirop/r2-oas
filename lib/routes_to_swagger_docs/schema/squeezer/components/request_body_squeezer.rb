require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodySqueezer < BaseSqueezer
        def initialize(schema_data = {}, options = {})
          @schema_data = schema_data
        end

        def remake_components_request_bodies
          { "requestBodies" => @schema_data["components"]["requestBodies"] }
        end
      end
    end
  end
end