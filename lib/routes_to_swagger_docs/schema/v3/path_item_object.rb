# reference
# https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#path-item-object
# Support Field Name: get, put, post, delete, patch
require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathItemObject < BaseObject
        SUPPORT_FIELD_NAME = %w(get put post delete patch)
  
        attr_accessor :verb, :tag_name
  
        def initialize(route_data)
          @verb = route_data[:verb]
          @tag_name = route_data[:tag_name]
          support_field_name?(verb)
        end
  
        def to_doc
          {
            # Operation Object (Support Filed Type is String)
            "#{verb}" => {
              "tags" => ["#{tag_name}"],
              "summary" => "#{verb} summary",
              "description" => "#{verb} description",
              # Response Object
              "responses" => {
                "default" => {
                  "description" => ""
                }
              },
              "deprecated" => false
            }
          }
        end
  
        private
        
        def support_field_name?(field_name)
          raise RuntimeError,  "Invalid filed name #{field_name}" unless SUPPORT_FIELD_NAME.include?(field_name)
        end
      end
    end
  end
end