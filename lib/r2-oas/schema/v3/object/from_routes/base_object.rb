# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/plugin/executor'
require 'r2-oas/schema/v3/object/from_routes/all'

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

          @opts = opts
          @plugin_executor = ::R2OAS::Plugin::Executor.new(@plugins, opts)
        end

        def info_object_class
          InfoObject
        end

        def paths_object_class
          PathsObject
        end

        def path_item_object_class
          PathItemObject
        end

        def external_document_object_class
          ExternalDocumentObject
        end

        def components_object_class
          ComponentsObject
        end

        def components_schema_object_class
          Components::SchemaObject
        end

        def components_request_body_object_class
          Components::RequestBodyObject
        end

        private

        def app_configuration_options
          R2OAS.app_configuration_options
        end

        attr_accessor *AppConfiguration::VALID_OPTIONS_KEYS

        def to_doc
          raise 'Implement Inherit Class'
        end
      end
    end
  end
end
