require 'forwardable'
require_relative '../../plugins/schema/v3/hookable_base_object'
require_relative '../../routing/components/path_component'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathItemObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        extend Forwardable
        # reference
        # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#path-item-object
        # Support Field Name: get, put, post, delete, patch
        SUPPORT_FIELD_NAME = %w(get put post delete patch)
        SUPPORT_HTTP_STATUS = %w(200 204 404 422).freeze

        def_delegators :@http_status_manager, :http_statuses
    
        def initialize(route_data, path)
          super(route_data)
          @path_comp                    = Routing::PathComponent.new(path)
          @path                         = @path_comp.symbol_to_brace
          @route_data                   = route_data
          @verb                         = route_data[:verb]
          @tag_name                     = route_data[:tag_name]
          @schema_name                  = route_data[:schema_name]
          @required_parameters          = route_data[:required_parameters]
          @format_name                  = create_format_name
          @http_status_manager          = HttpStatusManager.new(@path, @verb, http_statuses_when_http_method)
          support_field_name? if route_data.has_key?(:verb)
        end

        def to_doc
          execute_before_create(@path)
          create_doc
          execute_after_create(@path)
          doc
        end
  
        def create_doc
          result = { "#{@verb}" => data_when_verb }
          attach_media_type!(result)
          attach_parameters!(result)
          doc.merge!(result)
        end

        # MEMO:
        # hook methods
        def components_schema_name(doc, path_component, tag_name, verb, http_status, schema_name)
          schema_name
        end
  
        private

        def data_when_verb
          result = {
            "tags" => ["#{@tag_name}"],
            "summary" => "#{@verb} summary",
            "description" => "#{@verb} description",
            # Response Object
            "responses" => {},
            "deprecated" => false
          }
          result["responses"].deep_merge!(responses_when_http_status)
          result
        end

        def responses_when_http_status
          http_statuses.each_with_object({}) do |http_status, result|
            result.deep_merge!({
              http_status => {
                "description" => "#{@tag_name} description",
                "content" => {
                  "application/json" => {
                    "schema" => {
                      "$ref" => "#/components/schemas/#{_components_schema_name(http_status)}"
                    }
                  }
                }
              }
            })
          end
        end

        def _components_schema_name(http_status)
          components_schema_name(doc, @path_comp, @tag_name, @verb, http_status, @schema_name)
        end

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

        class HttpStatusManager
          def initialize(path, verb, http_statuses_when_http_method)
            @path_comp                    = Routing::PathComponent.new(path)
            @verb                         = verb
            @http_statuses_when_http_method = http_statuses_when_http_method
          end

          def http_statuses
            key = @path_comp.exist_path_parameters? ? :path_parameter : :default
            @http_statuses_when_http_method[@verb.to_sym][key]
          end
        end
      end
    end
  end
end