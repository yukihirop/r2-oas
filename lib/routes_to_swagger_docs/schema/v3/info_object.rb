require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class InfoObject < BaseObject
        def to_doc
          {
            "title" => "Swagger API Document Title",
            "description" => "This is a sample server Petstore server.  You can find out more about
            Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,
            #swagger](http://swagger.io/irc/).  For this sample, you can use the api key
            `special-key` to test the authorization filters.",
            "termsOfService" => "http://swagger.io/terms/",
            # Contact Object
            "contact" => {
              "name" => "",
              "url" => ""
            },
            # License Object
            "license" => {
              "name" => "",
              "url" => ""
            },
            "version" => "1.0.0"
          }
        end
      end
    end
  end
end