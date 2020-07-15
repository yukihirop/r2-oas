# frozen_string_literal: true

require 'r2-oas/shared/callable'
require_relative 'base_object'
require_relative 'components/schema_object'
require_relative 'components/request_body_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class PathItemObject < BaseObject
          include ::R2OAS::Callable

          def initialize(doc, ref, opts = {})
            super(opts)
            @doc = doc
            @ref = ref
          end

          def to_doc
            referenced_doc(@doc, @ref)
            callback = proc { |data| data[:receiver].send(data[:method]) }
            deep_call(@doc, '$ref', callback)

            ref_dup = @ref.dup
            execute_transform_plugins(:path_item, @doc, ref_dup)
            @doc
          end

          private

          def referenced_doc(data, ref)
            data.each do |(verb, data_when_verb)|
              ref[:verb] = verb
              ref[:tag_name] = data_when_verb['tags'].first

              data_when_verb['responses'].each do |http_status, data_when_http_status|
                ref[:http_status] = http_status
                data_when_http_status = deep_call(data_when_http_status, '$ref', callback_schema(ref))
                data[verb]['responses'][http_status] = data_when_http_status
              end

              value = data_when_verb['requestBody']&.fetch('$ref', nil)
              # MEMO:
              # requestBody does not depend on http_status
              ref_dup = ref.dup
              ref_dup.delete(:http_status)
              data[verb]['requestBody']['$ref'] = callback_request_body(ref_dup).call(value) if value.present?
            end

            data
          end

          def callback_schema(ref)
            root_doc_dup = root_doc

            # e.g.) key = '#/components/schemas/api.v1.Task'
            proc do |key|
              schema_obj, schema_type, schema_name = key.split('/').slice(1..-1)
              schema_doc = root_doc_dup&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(schema_name, nil) || {}
              obj = Components::SchemaObject.new(schema_doc, ref.merge({ from: :path_item, schema_name: schema_name }), opts)
              obj_store.add('components/schemas', key, obj)
              { receiver: obj, method: :ref_path }
            end
          end

          def callback_request_body(ref)
            root_doc_dup = root_doc

            # e.g.) key = '#/components/requestBodies/api.v1.Task'
            proc do |key|
              schema_obj, schema_type, schema_name = key.split('/').slice(1..-1)
              request_body_doc = root_doc_dup&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(schema_name, nil) || {}
              obj = Components::RequestBodyObject.new(request_body_doc, ref.merge({ from: :path_item, schema_name: schema_name }), opts)
              obj_store.add('components/requestBodies', key, obj)
              { receiver: obj, method: :ref_path }
            end
          end
        end
      end
    end
  end
end
