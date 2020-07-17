# frozen_string_literal: true

require 'r2-oas/shared/callable'
require_relative 'base_object'
require_relative 'components/schema_object'
require_relative 'components/request_body_object'
require_relative 'utils/deep_methods'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class PathItemObject < BaseObject
          include ::R2OAS::Callable
          include DeepMethods

          def initialize(doc, ref, opts = {})
            super(opts)
            @doc = doc
            @parent_ref = ref
            resolve_dependencies!
          end

          def to_doc
            call_ref_path!

            # MEMO:
            # If it is overwritten, it may lead to unexpected problems, so give a copy
            execute_transform_plugins(:path_item, @doc, ref_dup)
            @doc
          end

          # Breaking changes to @doc
          def resolve_dependencies!
            local_ref = ref_dup

            @doc.each do |verb, data_when_verb|
              local_ref[:verb] = verb
              local_ref[:tag_name] = data_when_verb['tags'].first

              resolve_dependencies_at_schema!(@doc, verb, data_when_verb, local_ref)
              resolve_dependencies_at_request_body!(@doc, verb, data_when_verb, local_ref)
            end
          end

          def call_ref_path!
            callback = proc { |obj| obj.ref_path }
            deep_call(@doc, '$ref', callback)
          end

          private

          def ref_dup
            @parent_ref.dup
          end

          def resolve_dependencies_at_schema!(data, verb, data_when_verb, local_ref)
            data_when_verb['responses'].each do |http_status, data_when_http_status|
              local_ref[:http_status] = http_status

              deep_replace!(data_when_http_status, '$ref') do |ref_path|
                schema_obj, schema_type, schema_name = ref_path.split('/').slice(1..-1)
                schema_doc = root_doc&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(schema_name, nil) || {}

                local_ref_dup = local_ref.dup
                obj = Components::SchemaObject.new(schema_doc, local_ref_dup.merge({ from: :path_item, schema_name: schema_name }), opts)

                obj_store.add('components/schemas', schema_name, obj)
                obj
              end

              data[verb]['responses'][http_status] = data_when_http_status
            end
          end

          def resolve_dependencies_at_request_body!(data, verb, data_when_verb, local_ref)
            deep_replace!(data_when_verb['requestBody'], '$ref') do |ref_path|
              schema_obj, schema_type, schema_name = ref_path.split('/').slice(1..-1)
              schema_doc = root_doc&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(schema_name, nil) || {}

              # MEMO:
              # requestBody does not depend on http_status
              local_ref_dup = local_ref.dup
              local_ref_dup.delete(:http_status)
              obj = Components::RequestBodyObject.new(schema_doc, local_ref_dup.merge({ from: :path_item, schema_name: schema_name }), opts)

              obj_store.add('components/requestBodies', schema_name, obj)

              data[verb]['requestBody']['$ref'] = obj
              obj
            end
          end
        end
      end
    end
  end
end
