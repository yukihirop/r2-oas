require_relative '../../plugins/schema/v3/hookable_base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathItemObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        # reference
        # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#path-item-object
        # Support Field Name: get, put, post, delete, patch
        SUPPORT_FIELD_NAME = %w(get put post delete patch)
    
        def initialize(route_data, path)
          super(route_data)
          @path        = path
          @route_data  = route_data
          @verb        = route_data[:verb]
          @tag_name    = route_data[:tag_name]
          @schema_name = route_data[:schema_name]
          @format_name = create_format_name
          @required_parameters = route_data[:required_parameters]
          support_field_name? if route_data.has_key?(:verb)
        end

        def to_doc
          execute_before_create(@path)
          create_doc
          execute_after_create(@path)
          doc
        end
  
        def create_doc
          result = {
            # Operation Object (Support Filed Type is String)
            "#{@verb}" => {
              "tags" => ["#{@tag_name}"],
              "summary" => "#{@verb} summary",
              "description" => "#{@verb} description",
              # Response Object
              "responses" => {
                "default" => {
                  "description" => ""
                },
                "200" => {
                  "description" => "#{@tag_name} description",
                  "content" => {
                    "application/json" => {
                      "schema" => {
                        "$ref" => "#/components/schemas/#{@schema_name}"
                      }
                    }
                  }
                }
              },
              "deprecated" => false
            }
          }
          attach_media_type!(result)
          attach_parameters!(result)
          doc.merge!(result)
        end
  
        private

        def create_format_name
          format_name = @route_data[:format_name]
          if format_name.blank?
            ""
          else
            "application/#{format_name}"
          end
        end

        def attach_media_type!(schema)
          return schema if @format_name.blank?
          merge_schema = {
            "200" => {
              "description" => "responses description",
              "content" => {
                "#{@format_name}" => {}
              }
            }
          }
          schema["#{@verb}"]["responses"].deep_merge!(merge_schema)
          schema
        end

        def attach_parameters!(schema)
          return schema if @required_parameters.blank?
          content = @required_parameters.each_with_object([]) do |(parameter_name, parameter_data), result|
            result.push(
              {
                "name" => "#{parameter_name}",
                "in" => "path",
                "description" => "#{parameter_name}",
                "required" => true,
                "schema" => {
                  "type" => parameter_data[:type]
                }
              }
            )
          end

          merge_schema = {
            "parameters" => content
          }

          schema["#{@verb}"].deep_merge!(merge_schema)
          schema
        end
        
        def support_field_name?
          raise RuntimeError,  "Invalid filed name #{field_name}" unless SUPPORT_FIELD_NAME.include?(@verb)
        end
      end
    end
  end
end