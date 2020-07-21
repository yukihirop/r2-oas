# frozen_string_literal: true

require_relative 'base_object'
require_relative 'components/schema_object'
require_relative 'components/request_body_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class ComponentsObject < BaseObject
          def initialize(doc, opts = {})
            super(opts)
            @doc = doc
          end

          def to_doc
            create_doc
            @doc
          end

          private

          def create_doc
            create_components_schema_docs!
            create_components_request_body_docs!
          end

          def create_components_schema_docs!
            result = obj_store.gets('components/schemas').each_with_object({}) do |obj, data|
              data[obj.schema_name] = obj.to_doc
            end
            @doc.merge!('schemas' => result) if result.present?
          end

          def create_components_request_body_docs!
            result = obj_store.gets('components/requestBodies').each_with_object({}) do |obj, data|
              data[obj.schema_name] = obj.to_doc
            end
            @doc.merge!('requestBodies' => result) if result.present?
          end
        end
      end
    end
  end
end
