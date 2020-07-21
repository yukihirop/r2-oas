# frozen_string_literal: true

require 'fileutils'

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
      load_local_plugins
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

    def load_tasks
      tasks_path = File.expand_path("#{root_dir_path}/#{local_tasks_dir_name}")
      Dir.glob("#{tasks_path}/**/*.rake").sort.each do |file|
        load file if FileTest.exists?(file)
      end
    end

    def init
      plugins_path = File.expand_path("#{root_dir_path}/#{local_plugins_dir_name}")
      plugins_helpers_path = "#{plugins_path}/helpers"
      tasks_path = File.expand_path("#{root_dir_path}/#{local_tasks_dir_name}")
      tasks_helpers_path = "#{tasks_path}/helpers"

      gitkeep_plugins_path = "#{plugins_path}/.gitkeep"
      gitkeep_plugins_helpers_path = "#{plugins_helpers_path}/.gitkeep"
      gitkeep_tasks_path = "#{tasks_path}/.gitkeep"
      gitkeep_tasks_helpers_path = "#{tasks_helpers_path}/.gitkeep"

      FileUtils.mkdir_p(plugins_helpers_path) unless FileTest.exists?(plugins_helpers_path)
      FileUtils.mkdir_p(tasks_helpers_path) unless FileTest.exists?(tasks_helpers_path)

      File.write(gitkeep_plugins_path, '') unless FileTest.exists?(gitkeep_plugins_path)
      File.write(gitkeep_plugins_helpers_path, '') unless FileTest.exists?(gitkeep_plugins_helpers_path)
      File.write(gitkeep_tasks_path, '') unless FileTest.exists?(gitkeep_tasks_path)
      File.write(gitkeep_tasks_helpers_path, '') unless FileTest.exists?(gitkeep_tasks_helpers_path)
      paths_config.create_dot_paths
    end

    def output_dir_path
      output_path.to_s.split('/').slice(0..-2).join('/')
    end

    private

    def load_local_plugins
      plugins_path = File.expand_path("#{root_dir_path}/#{local_plugins_dir_name}")
      Dir.glob("#{plugins_path}/**/*.rb").sort.each do |file|
        require file if FileTest.exists?(file)
      end
    end

    def set_default_for_configuration(target)
      AppConfiguration.set_default(target)
    end

    def set_default_for_pluggable(target)
      PluggableConfiguration.set_default(target)
    end
  end
end
