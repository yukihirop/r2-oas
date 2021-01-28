# frozen_string_literal: true

require_relative 'base_object'
require_relative 'tag_object'
require_relative 'server_object'
require_relative 'info_object'
require_relative 'external_document_object'
require_relative 'components_object'
require_relative 'paths_object'

module R2OAS
  module Schema
    module V3
      class OpenapiObject < BaseObject
        def initialize(routes_data, tags_data, schemas_data, opts = {})
          super(opts)
          @routes_data = routes_data
          @tags_data = tags_data
          @schemas_data = schemas_data
        end

        def to_doc
          result = {
            'openapi' => '3.0.0',
            'info' => info_doc,
            'tags' => tags_doc,
            'paths' => paths_doc,
            'externalDocs' => external_docs_doc,
            'servers' => servers_doc,
            'components' => components_doc
          }
          doc.merge!(result)
        end

        private

        def info_doc
          InfoObject.new(@opts).to_doc
        end

        def tags_doc
          TagObject.new(@tags_data, @opts).to_doc
        end

        def paths_doc
          PathsObject.new(@routes_data, @opts).to_doc
        end

        def external_docs_doc
          ExternalDocumentObject.new(@opts).to_doc
        end

        def servers_doc
          ServerObject.new(@opts).to_doc
        end

        def components_doc
          ComponentsObject.new(@routes_data, @opts).to_doc
        end
      end
    end
  end
end
