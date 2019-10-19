# frozen_string_literal: true

require 'r2-oas/plugins/schema/v3/object/hookable_base_object'

module R2OAS
  module Schema
    module V3
      class ExternalDocumentObject < R2OAS::Plugins::Schema::V3::HookableBaseObject
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
