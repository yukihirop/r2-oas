require_relative 'base_object'
require_relative 'tag_object'
require_relative 'server_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class OpenapiObject < BaseObject
        def initialize(routes_data, tags_data, schemas_data)
          super(schemas_data)
          @routes_data  = routes_data
          @tags_data    = tags_data
          @schemas_data = schemas_data
        end

        def to_doc
          {
            "openapi" => "3.0.0",
            "info" => info_doc,
            "tags" => tags_doc,
            "paths" => paths_doc,
            "externalDocs" => external_docs_doc,
            "servers" => servers_doc,
            "components" => components_doc 
          }
        end

        private

        def info_doc
          info_object_class.new.to_doc
        end

        def tags_doc
          TagObject.new(@tags_data).to_doc
        end

        def paths_doc
          paths_object_class.new(@routes_data).to_doc
        end

        def external_docs_doc
          external_document_object_class.new.to_doc
        end

        def servers_doc
          ServerObject.new.to_doc
        end

        def components_doc
          components_object_class.new(@routes_data).to_doc
        end
      end
    end
  end
end