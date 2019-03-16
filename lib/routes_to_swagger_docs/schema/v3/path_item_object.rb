# reference
# https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#path-item-object
# Support Field Name: get, put, post, delete, patch
require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathItemObject < BaseObject
        SUPPORT_FIELD_NAME = %w(get put post delete patch)
  
        attr_accessor :verb, :tag_name, :format_name
  
        def initialize(route_data)
          @verb = route_data[:verb]
          @tag_name = route_data[:tag_name]
          @format_name = attach_application route_data[:format_name]
          support_field_name?(verb)
        end
  
        def to_doc
          schema = {
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
          attach_media_type(schema)
        end
  
        private

        def attach_application(format_name)
          if format_name.blank?
            ""
          else
            "application/#{format_name}"
          end
        end

        def attach_media_type(schema)
          return schema if format_name.blank?
          merge_schema = {
            "200" => {
              "description" => "responses description",
              "content" => {
                "#{format_name}" => {}
              }
            }
          }
          schema["#{verb}"]["responses"].deep_merge!(merge_schema)
          schema
        end
        
        def support_field_name?(field_name)
          raise RuntimeError,  "Invalid filed name #{field_name}" unless SUPPORT_FIELD_NAME.include?(field_name)
        end
      end
    end
  end
end