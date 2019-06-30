# frozen_string_literal: true

module RoutesToSwaggerDocs
  module Schema
    module V3
      class BaseObject
        def initialize(*_args)
          BaseConfiguration::VALID_OPTIONS_KEYS.each do |key|
            send("#{key}=", base_configuration_options[key])
          end

          PluggableConfiguration::VALID_OPTIONS_KEYS.each do |key|
            instance_variable_set(:"@#{key}", pluggable_configuration_options[key])
          end
        end

        def info_object_class
          @use_object_classes[:info_object]
        end

        def paths_object_class
          @use_object_classes[:paths_object]
        end

        def path_item_object_class
          @use_object_classes[:path_item_object]
        end

        def external_document_object_class
          @use_object_classes[:external_document_object]
        end

        def components_object_class
          @use_object_classes[:components_object]
        end

        def components_schema_object_class
          @use_object_classes[:components_schema_object]
        end

        def components_request_body_object_class
          @use_object_classes[:components_request_body_object]
        end

        private

        def base_configuration_options
          RoutesToSwaggerDocs.base_configuration_options
        end

        def pluggable_configuration_options
          RoutesToSwaggerDocs.pluggable_configuration_options
        end

        # Can not define attr_accessor for PluggableConfiguration::VALID_OPTIONS_KEYS.
        # Because, PuggableConfiguration module is not loaded when this class is loaded.
        attr_accessor *BaseConfiguration::VALID_OPTIONS_KEYS

        def to_doc
          raise 'Implement Inherit Class'
        end
      end
    end
  end
end
