require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ExternalDocumentObject < BaseObject
        def to_doc
          {
            "description" => "",
            "url" => ""
          }
        end
      end
    end
  end
end