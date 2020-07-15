# frozen_string_literal: true

require 'r2-oas/dynamic/schema/v3/object/from_routes/hookable_base_object'

module R2OAS
  module Schema
    module V3
      class ExternalDocumentObject < R2OAS::Dynamic::Schema::V3::HookableBaseObject
        def to_doc
          execute_before_create
          create_doc
          execute_after_create
          execute_transform_plugins(:external_document, doc)
          doc
        end

        private

        def create_doc
          result = {
            'description' => '',
            'url' => ''
          }
          doc.merge!(result)
        end
      end
    end
  end
end
