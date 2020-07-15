# frozen_string_literal: true

require 'r2-oas/shared/callable'
require_relative '../base_object'
require_relative 'schema_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        module Components
          class RequestBodyObject < ::R2OAS::Schema::V3::FromFiles::BaseObject
            include ::R2OAS::Callable

            def initialize(doc, ref, opts)
              super(opts)
              @doc = doc
              @ref = ref
            end

            def to_doc
              # MEMO:
              # Operate the schemas used in requestBodies
              deep_call(@doc, '$ref', callback_schema(@ref))

              callback = proc { |data| data[:receiver].send(data[:method]) }
              deep_call(@doc, '$ref', callback)

              # If it is overwritten, it may lead to unexpected problems, so give a copy
              ref_dup = @ref.dup
              execute_transform_plugins(:components_request_body, @doc, ref_dup)
              @doc
            end

            def schema_name
              ref_dup = @ref.dup
              execute_transform_plugins(:components_request_body_name, ref_dup)
              ref_dup[:schema_name]
            end

            private

            def ref_path
              "#/components/requestBodies/#{schema_name}"
            end

            def callback_schema(ref)
              root_doc_dup = root_doc

              # e.g.) k = '#/components/schemas/api.v1.Task'
              proc do |key|
                schema_obj, schema_type, schema_name = key.split('/').slice(1..-1)
                schema_doc = root_doc_dup&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(schema_name, nil) || {}
                obj = Components::SchemaObject.new(schema_doc, ref.merge({ from: :request_body }), opts)
                obj_store.add('components/schemas', key, obj)
                { receiver: obj, method: :ref_path }
              end
            end
          end
        end
      end
    end
  end
end
