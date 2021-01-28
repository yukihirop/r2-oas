# frozen_string_literal: true

require_relative 'base_object'

module R2OAS
  module Schema
    module V3
      class ExternalDocumentObject < BaseObject
        def to_doc
          create_doc
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
