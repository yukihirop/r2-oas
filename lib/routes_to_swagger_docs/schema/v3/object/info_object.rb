# frozen_string_literal: true

require_relative '../../plugins/schema/object/hookable_base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class InfoObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        def create_doc
          result = {
            'title' => 'Swagger API Document Title',
            'description' => "This is a sample server Petstore server.  You can find out more about
            Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,
            #swagger](http://swagger.io/irc/).  For this sample, you can use the api key
            `special-key` to test the authorization filters.",
            'termsOfService' => 'http://swagger.io/terms/',
            # Contact Object
            'contact' => {
              'name' => '',
              'url' => ''
            },
            # License Object
            'license' => {
              'name' => '',
              'url' => ''
            },
            'version' => '1.0.0'
          }
          doc.merge!(result)
        end
      end
    end
  end
end
