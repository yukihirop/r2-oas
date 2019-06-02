#frozen_string_literal: true

require_relative 'schema/v3/public'

module RoutesToSwaggerDocs
  module PluggableConfiguration

    DEFAULT_USE_OBJECT_CLASSES = {
      info_object:              RoutesToSwaggerDocs::Schema::V3::InfoObject,
      paths_object:             RoutesToSwaggerDocs::Schema::V3::PathsObject,
      path_item_object:         RoutesToSwaggerDocs::Schema::V3::PathItemObject,
      external_document_object: RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject,
      components_object:        RoutesToSwaggerDocs::Schema::V3::ComponentsObject,
      schema_object:            RoutesToSwaggerDocs::Schema::V3::SchemaObject,
    }

     VALID_OPTIONS_KEYS = [
      :use_object_classes
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    private

    module_function

    def set_default(target)
      target.use_object_classes = DEFAULT_USE_OBJECT_CLASSES
    end
  end
end