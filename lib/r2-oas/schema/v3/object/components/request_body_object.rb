# frozen_string_literal: true

require 'r2-oas/dynamic/schema/v3/object/hookable_base_object'
require 'r2-oas/schema/v3/manager/file/components_file_manager'

module R2OAS
  module Schema
    module V3
      module Components
        class RequestBodyObject < R2OAS::Dynamic::Schema::V3::HookableBaseObject
          def initialize(route_data, path, opts = {})
            super(opts)
            @path_comp   = Routing::PathComponent.new(path)
            @path        = @path_comp.symbol_to_brace
            @route_data  = route_data
            @verb        = route_data[:verb]
            @tag_name    = route_data[:tag_name]
            @schema_name = route_data[:schema_name]
          end

          def to_doc
            execute_before_create(@schema_name)
            create_doc do
              child_file_manager = ComponentsFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
              schema_object = components_schema_object_class.new(@route_data, @path, @opts)

              unless child_file_manager.skip_save?
                result = {
                  'components' => {
                    'schemas' => {
                      _components_schema_name => schema_object.to_doc
                    }
                  }
                }
                doc.deep_merge!(
                  'has_one' => {
                    'type' => 'schema',
                    'original_path' => child_file_manager.original_path,
                    'data' => result
                  }
                )
              end
            end
            execute_after_create(@schema_name)
            execute_transform_plugins(:components_request_body, doc, @schema_name)
            doc
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
            file_manager = ComponentsFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
            (@verb.in? http_methods_when_generate_request_body) && !file_manager.skip_save?
          end

          private
          
          def create_doc
            file_manager = ComponentsFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
            doc.deep_merge!(
              'content' => {
                'application/json' => {
                  'schema' => {
                    '$ref' => file_manager.original_path
                  }
                }
              }
            )
            yield if block_given?
          end

          def _components_schema_name
            schema_name = components_schema_name(doc, @path_comp, @tag_name, @verb, @schema_name)
            # MEMO:
            # Allow primitive types that cannot be passed by reference to be passed by reference
            # This is Compromise
            ref = { schema_name: schema_name }
            execute_transform_plugins(:components_schema_name_at_request_body, ref, doc, @path_comp, @tag_name, @verb)
            ref[:schema_name]
          end

          def _components_request_body_name
            schema_name = components_request_body_name(doc, @path_comp, @tag_name, @verb, @schema_name)
            # MEMO:
            # Allow primitive types that cannot be passed by reference to be passed by reference
            # This is Compromise
            ref = { schema_name: schema_name }
            execute_transform_plugins(:components_request_body_name, ref, doc, @path_comp, @tag_name, @verb)
            ref[:schema_name]
          end
        end
      end
    end
  end
end
