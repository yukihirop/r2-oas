# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/plugins/schema/v3/object/hookable_base_object'
require 'r2-oas/routing/components/path_component'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathItemObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        extend Forwardable
        # reference
        # https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#path-item-object
        # Support Field Name: get, put, post, delete, patch
        SUPPORT_FIELD_NAME = %w[get put post delete patch].freeze

        def_delegators :@http_status_manager, :http_statuses

        def initialize(route_data, path)
          super()
          @path_comp                      = Routing::PathComponent.new(path)
          @path                           = @path_comp.symbol_to_brace
          @route_data                     = route_data
          @verb                           = route_data[:verb]
          @tag_name                       = route_data[:tag_name]
          @schema_name                    = route_data[:schema_name]
          @required_parameters            = route_data[:required_parameters]
          @format_name                    = create_format_name
          @http_status_manager            = HttpStatusManager.new(@path, @verb, http_statuses_when_http_method)
          @components_schema_object       = components_schema_object_class.new(route_data, path)
          @components_request_body_object = components_request_body_object_class.new(route_data, path)
          support_field_name? if route_data.key?(:verb)
        end

        def to_doc
          execute_before_create(@path)
          create_doc
          execute_after_create(@path)
          doc
        end

        def create_doc
          result = { @verb.to_s => data_when_verb }
          attach_request_body!(result)
          attach_media_type!(result)
          attach_parameters!(result)
          doc.merge!(result)
        end

        private

        def data_when_verb
          result = {
            'tags' => [@tag_name.to_s],
            'summary' => "#{@verb} summary",
            'description' => "#{@verb} description",
            # Response Object
            'responses' => {},
            'deprecated' => false
          }
          result['responses'].deep_merge!(responses_when_http_status)
          result
        end

        def responses_when_http_status
          http_statuses.each_with_object({}) do |http_status, result|
            result.deep_merge!(
              http_status => {
                'description' => "#{@tag_name} description",
                'content' => {
                  'application/json' => {
                    'schema' => {
                      '$ref' => "#/components/schemas/#{_components_schema_name(http_status)}"
                    }
                  }
                }
              }
            )
          end
        end

        def _components_schema_name(http_status)
          @components_schema_object.send(:_components_schema_name, http_status)
        end

        def _components_request_body_name
          @components_request_body_object.send(:_components_request_body_name)
        end

        def create_format_name
          format_name = @route_data[:format_name]
          if format_name.blank?
            ''
          else
            "application/#{format_name}"
          end
        end

        def attach_request_body!(schema)
          return schema unless @components_request_body_object.generate?

          merge_schema = {
            '$ref' => "#/components/requestBodies/#{_components_request_body_name}"
          }
          schema[@verb.to_s]['requestBody'] = {}
          schema[@verb.to_s]['requestBody'].deep_merge!(merge_schema)
          schema
        end

        def attach_media_type!(schema)
          return schema if @format_name.blank?

          merge_schema = {
            '200' => {
              'description' => 'responses description',
              'content' => {
                @format_name.to_s => {}
              }
            }
          }
          schema[@verb.to_s]['responses'].deep_merge!(merge_schema)
          schema
        end

        def attach_parameters!(schema)
          return schema if @required_parameters.blank?

          content = @required_parameters.each_with_object([]) do |(parameter_name, parameter_data), result|
            result.push(
              'name' => parameter_name.to_s,
              'in' => 'path',
              'description' => parameter_name.to_s,
              'required' => true,
              'schema' => {
                'type' => parameter_data[:type]
              }
            )
          end

          merge_schema = {
            'parameters' => content
          }

          schema[@verb.to_s].deep_merge!(merge_schema)
          schema
        end

        def support_field_name?
          raise "Invalid filed name #{field_name}" unless SUPPORT_FIELD_NAME.include?(@verb)
        end

        class HttpStatusManager
          def initialize(path, verb, http_statuses_when_http_method)
            @path_comp                      = Routing::PathComponent.new(path)
            @verb                           = verb
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
