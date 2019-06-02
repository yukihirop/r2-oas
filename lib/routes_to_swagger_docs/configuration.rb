#frozen_string_literal: true

require_relative 'base_configuration'
require_relative 'pluggable_configuration'

module RoutesToSwaggerDocs
  module Configuration
    extend BaseConfiguration
    extend PluggableConfiguration

    VALID_OPTIONS_KEYS = BaseConfiguration::VALID_OPTIONS_KEYS + PluggableConfiguration::VALID_OPTIONS_KEYS

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.send :set_default_for_configuration, base
      base.send :set_default_for_pluggable, base
    end

    def configure(&block)
      yield self if block_given?
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def base_configuration_options
      BaseConfiguration::VALID_OPTIONS_KEYS.inject({}) do |option, key|
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
      BaseConfiguration.set_default(target)
    end

    def set_default_for_pluggable(target)
      PluggableConfiguration.set_default(target)
    end
  end
end
