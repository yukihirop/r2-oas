require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ServerObject < BaseObject
        def to_doc
          {
            "url" => "https://example.com",
            "description" => "example",
            # Do not Server Variable Object
          }
        end
      end
    end
  end
end