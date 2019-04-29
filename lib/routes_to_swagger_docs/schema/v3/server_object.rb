require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ServerObject < BaseObject
        def to_doc
          {
            "url" => "http://localhost:3000",
            "description" => "localhost",
            # Do not Server Variable Object
          }
        end
      end
    end
  end
end