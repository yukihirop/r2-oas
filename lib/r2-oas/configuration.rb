# frozen_string_literal: true

require_relative 'app_configuration'
require_relative 'pluggable_configuration'
require_relative 'configuration/paths_config'
require_relative 'logger/stdout_logger'

module R2OAS
  module Configuration
    extend AppConfiguration
    extend PluggableConfiguration

    PUBLIC_VALID_OPTIONS_KEYS = AppConfiguration::VALID_OPTIONS_KEYS + PluggableConfiguration::VALID_OPTIONS_KEYS

    UNPUBLIC_VALID_OPTIONS_KEYS = %i[
      paths_config
      logger
    ].freeze

    VALID_OPTIONS_KEYS = PUBLIC_VALID_OPTIONS_KEYS + UNPUBLIC_VALID_OPTIONS_KEYS

    attr_accessor *PUBLIC_VALID_OPTIONS_KEYS

    def self.extended(base)
      base.send :set_default_for_configuration, base
      base.send :set_default_for_pluggable, base
    end

    def configure
      yield self if block_given?
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def logger
      @_stdout_logger ||= StdoutLogger.new
    end

    def paths_config
      @_paths_config ||= PathsConfig.new(root_dir_path, schema_save_dir_name)
    end

    def app_configuration_options
      AppConfiguration::VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def pluggable_configuration_options
      PluggableConfiguration::VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    private

    def set_default_for_configuration(target)
      AppConfiguration.set_default(target)
    end

    def set_default_for_pluggable(target)
      PluggableConfiguration.set_default(target)
    end
  end
end
