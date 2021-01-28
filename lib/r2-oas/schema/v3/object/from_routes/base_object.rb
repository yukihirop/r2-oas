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

          @opts = opts
          @plugin_executor = ::R2OAS::Plugin::Executor.new(@plugins, opts)
        end

        def doc
          @doc ||= {}
        end

        def to_doc
          raise 'Implement Inherit Class'
        end

        private

        def app_configuration_options
          R2OAS.app_configuration_options
        end

        attr_accessor *AppConfiguration::VALID_OPTIONS_KEYS
      end
    end
  end
end
