# frozen_string_literal: true

require 'forwardable'
require 'key_flatten'

require 'r2-oas/plugin/executor'
require 'r2-oas/schema/v3/object/store'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class BaseObject
          extend Forwardable

          class << self
            def obj_store
              ::R2OAS::Schema::V3::Store.create(:obj)
            end
          end

          def_delegators :@plugin_executor, :execute_transform_plugins

          def initialize(opts = {})
            @opts = opts
            plugins = app_configuration_options[:plugins]
            @plugin_executor = ::R2OAS::Plugin::Executor.new(plugins, opts)
          end

          def to_doc
            raise 'Implement Inherit Class'
          end

          private

          def obj_store
            self.class.obj_store
          end

          def set_root_doc(root_doc)
            obj_store.root_doc = root_doc.dup
          end

          def root_doc
            obj_store.root_doc
          end

          def set_components_name_list(root_doc)
            obj_store.components_schema_name_list = (root_doc.fetch('components', nil)&.fetch('schemas', nil) || {}).keys.sort.uniq
            obj_store.components_request_body_name_list = (root_doc.fetch('components', nil)&.fetch('schemas', nil) || {}).keys.sort.uniq
          end

          def app_configuration_options
            R2OAS.app_configuration_options
          end

          # Can not define attr_accessor for PluggableConfiguration::VALID_OPTIONS_KEYS.
          # Because, PuggableConfiguration module is not loaded when this class is loaded.
          attr_accessor :opts
        end
      end
    end
  end
end
