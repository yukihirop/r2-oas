# frozen_string_literal: true

require 'r2-oas/schema/v3/object/from_routes/base_object'
require 'r2-oas/schema/v3/manager/file/components_file_manager'
require_relative 'schema_object'

module R2OAS
  module Schema
    module V3
      module Components
        class RequestBodyObject < R2OAS::Schema::V3::BaseObject
          def initialize(route_data, path, opts = {})
            super(opts)
            @path_comp   = Routing::PathComponent.new(path)
            @path        = @path_comp.symbol_to_brace
            @route_data  = route_data
            @verb        = route_data[:verb]
            @tag_name    = route_data[:tag_name]
            @schema_name = route_data[:schema_name]
            # MEMO:
            # Allow primitive types that cannot be passed by reference to be passed by reference
            # This is Compromise
            @ref         = { schema_name: @schema_name, tag_name: @tag_name, verb: @verb }
          end

          def to_doc
            create_doc do
              child_file_manager = ComponentsFileManager.new("#/components/schemas/#{_components_schema_name}", :ref)
              schema_object = Components::SchemaObject.new(@route_data, @path, @opts)

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
            doc
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
            @schema_name
          end

          def _components_request_body_name
            @schema_name
          end
        end
      end
    end
  end
end
