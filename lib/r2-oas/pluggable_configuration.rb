# frozen_string_literal: true

require_relative 'schema/v3/object/public'

module RoutesToSwaggerDocs
  module PluggableConfiguration
    # rubocop:disable Style/MutableConstant
    DEFAULT_USE_OBJECT_CLASSES = {
      info_object: RoutesToSwaggerDocs::Schema::V3::InfoObject,
      paths_object: RoutesToSwaggerDocs::Schema::V3::PathsObject,
      path_item_object: RoutesToSwaggerDocs::Schema::V3::PathItemObject,
      external_document_object: RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject,
      components_object: RoutesToSwaggerDocs::Schema::V3::ComponentsObject,
      components_schema_object: RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject,
      components_request_body_object: RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
    }
    # rubocop:enable Style/MutableConstant

    VALID_OPTIONS_KEYS = [
      :use_object_classes
    ].freeze

    attr_accessor *VALID_OPTIONS_KEYS

    private

    module_function

    def set_default(target)
      target.use_object_classes = DEFAULT_USE_OBJECT_CLASSES
    end
  end
end
