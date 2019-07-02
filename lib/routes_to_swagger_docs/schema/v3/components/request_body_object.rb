# frozen_string_literal: true

require_relative '../../../plugins/schema/v3/hookable_base_object'
require_relative '../../manager/file/components/schema_file_manager'

module RoutesToSwaggerDocs
  module Schema
    module V3
      module Components
        class RequestBodyObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
          def initialize(route_data, path)
            super()
            @path_comp                      = Routing::PathComponent.new(path)
            @path                           = @path_comp.symbol_to_brace
            @route_data                     = route_data
            @verb                           = route_data[:verb]
            @tag_name                       = route_data[:tag_name]
            @schema_name                    = route_data[:schema_name]
          end

          def to_doc
            execute_before_create(@schema_name)
            create_doc do
              components_schema_file_manager = RoutesToSwaggerDocs::Schema::Components::SchemaFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
              components_schema_object       = components_schema_object_class.new(@route_data, @path)

              unless components_schema_file_manager.skip_save?
                result = {
                  'components' => {
                    'schemas' => {
                      _components_schema_name => components_schema_object.to_doc
                    }
                  }
                }
                components_schema_file_manager.save(result.to_yaml)
              end
            end
            execute_after_create(@schema_name)
            doc
          end

          def create_doc
            components_schema_file_manager = RoutesToSwaggerDocs::Schema::Components::SchemaFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
            doc.deep_merge!(
              'content' => {
                'application/json' => {
                  'schema' => {
                    '$ref' => components_schema_file_manager.original_path
                  }
                }
              }
            )
            yield if block_given?
          end

          # MEMO:
          # please override in inherited class.
          def components_schema_name(_doc, _path_component, _tag_name, _verb, schema_name)
            schema_name
          end

          # MEMO:
          # please override in inherited class.
          def components_request_body_name(_doc, _path_component, _tag_name, _verb, schema_name)
            schema_name
          end

          def generate?
            @verb.in? http_methods_when_generate_request_body
          end

          private

          def _components_schema_name
            components_schema_name(doc, @path_comp, @tag_name, @verb, @schema_name)
          end

          def _components_request_body_name
            components_request_body_name(doc, @path_comp, @tag_name, @verb, @schema_name)
          end
        end
      end
    end
  end
end
