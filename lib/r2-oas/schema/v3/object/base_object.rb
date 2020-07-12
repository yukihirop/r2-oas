# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/plugin/executor'

module R2OAS
  module Schema
    module V3
      class BaseObject
        extend Forwardable

        def_delegators :@plugin_executor, :execute_transform_plugins

        def initialize(opts = {})
          AppConfiguration::VALID_OPTIONS_KEYS.each do |key|
            send("#{key}=", app_configuration_options[key])
          end

          PluggableConfiguration::VALID_OPTIONS_KEYS.each do |key|
            instance_variable_set(:"@#{key}", pluggable_configuration_options[key])
          end

          @opts = opts
          @plugin_executor = ::R2OAS::Plugin::Executor.new(@plugins, opts)
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

        def app_configuration_options
          R2OAS.app_configuration_options
        end

        def pluggable_configuration_options
          R2OAS.pluggable_configuration_options
        end

        # Can not define attr_accessor for PluggableConfiguration::VALID_OPTIONS_KEYS.
        # Because, PuggableConfiguration module is not loaded when this class is loaded.
        attr_accessor *AppConfiguration::VALID_OPTIONS_KEYS

        def to_doc
          raise 'Implement Inherit Class'
        end
      end
    end
  end
end
