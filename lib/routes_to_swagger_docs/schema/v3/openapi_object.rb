require_relative 'base_object'
require_relative 'info_object'
require_relative 'tag_object'
require_relative 'paths_object'
require_relative 'external_document_object'
require_relative 'server_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class OpenapiObject < BaseObject
        def initialize(routes_data, tags_data)
          @routes_data = routes_data
          @tags_data = tags_data
        end

        def to_doc
          {
            "openapi" => "3.0.0",
            "info" => info_doc,
            "tags" => tags_doc,
            "paths" => paths_doc,
            "externalDocs" => external_docs_doc,
            "servers" => servers_doc
          }
        end

        private

        attr_accessor :routes_data, :tags_data

        def info_doc
          InfoObject.new.to_doc
        end

        def tags_doc
          tags_data.each_with_object([]) do |tag_name, result|
            result.push TagObject.new(tag_name).to_doc
          end
        end

        def paths_doc
          PathsObject.new(routes_data).to_doc
        end

        def external_docs_doc
          ExternalDocumentObject.new.to_doc
        end

        def servers_doc
          [ServerObject.new.to_doc]
        end
      end
    end
  end
end