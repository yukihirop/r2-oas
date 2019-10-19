# frozen_string_literal: true

require_relative 'schema/v3/object/public'

module R2OAS
  module PluggableConfiguration
    # rubocop:disable Style/MutableConstant
    DEFAULT_USE_OBJECT_CLASSES = {
      info_object: R2OAS::Schema::V3::InfoObject,
      paths_object: R2OAS::Schema::V3::PathsObject,
      path_item_object: R2OAS::Schema::V3::PathItemObject,
      external_document_object: R2OAS::Schema::V3::ExternalDocumentObject,
      components_object: R2OAS::Schema::V3::ComponentsObject,
      components_schema_object: R2OAS::Schema::V3::Components::SchemaObject,
      components_request_body_object: R2OAS::Schema::V3::Components::RequestBodyObject
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
