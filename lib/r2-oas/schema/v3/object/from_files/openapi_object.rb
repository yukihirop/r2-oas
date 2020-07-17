# frozen_string_literal: true

require_relative 'base_object'
require_relative 'info_object'
require_relative 'paths_object'
require_relative 'external_document_object'
require_relative 'components_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class OpenapiObject < BaseObject
          def initialize(doc, opts = {})
            super(opts)
            @doc = doc
            set_root_doc(doc)
            set_components_name_list(doc)
          end

          def to_doc
            execute_transform_plugins(:setup)
            # MEMO:
            # Make sure paths_doc is run first
            # This is because the components object is stored in the store by executing paths_doc
            # and it is looped to generate the component document.
            result = {
              'openapi' => '3.0.0',
              'info' => info_doc,
              'tags' => @doc['tags'],
              'paths' => paths_doc,
              'externalDocs' => external_docs_doc,
              'servers' => @doc['servers'],
              'components' => components_doc
            }
            execute_transform_plugins(:teardown)
            result
          end

          private

          def info_doc
            InfoObject.new(@doc['info'], @opts).to_doc
          end

          def paths_doc
            PathsObject.new(@doc['paths'], @opts).to_doc
          end

          def external_docs_doc
            ExternalDocumentObject.new(@doc['externalDocs'], @opts).to_doc
          end

          def components_doc
            ComponentsObject.new(@doc['components'], @opts).to_doc
          end
        end
      end
    end
  end
end
