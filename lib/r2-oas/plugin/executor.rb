# frozen_string_literal: true

require_relative 'hookable'
require 'r2-oas/errors'

module R2OAS
  module Plugin
    class Executor
      extend ::R2OAS::Plugin::Hookable

      def initialize(plugins, opts)
        @plugins = plugins
        @use_plugin = !!opts[:use_plugin]
      end

      def execute_transform_plugins(hook_method, *args)
        return unless @use_plugin
        return unless @plugins.present?

        @plugin_map ||= self.class.plugin_map(@plugins)

        self.class.execute_transform_plugins(@plugin_map, hook_method, *args)
      end

      class << self
        attr_accessor :plugin_map

        def execute_transform_plugins(plugin_map, hook_method, *args)
          execute_plugins(plugin_map, :transform, hook_method, *args)
        end

        def execute_plugins(plugin_map, type, hook_method, *args)
          return unless plugin_map.present?

          plugins_info = plugin_map[type.to_sym][hook_method.to_sym]

          return if plugins_info.nil?

          plugins_info.each do |info|
            opts = info[:plugin_opts]
            klass = info[:plugin_klass]
            klass.send(:opts=, opts) if opts.present?
            klass.send(info[:execute_hook_method], *args)
          end
        end

        # e.g.)
        # {
        #   transform: {
        #     setup: [
        #       { plugin_name: 'r2oas-transform-plugin-sample1', plugin_klass: Sample1Plugin, hook_method: :setup },
        #       { plugin_name: 'r2oas-transform-plugin-sample2', plugin_klass: Sample2Plugin, hook_method: :setup },
        #     ],
        #     info: [
        #       { plugin_name: 'r2oas-transform-plugin-sample1', plugin_klass: Sample1Plugin, hook_method: :info },
        #     ]
        #   }
        # }
        #
        def plugin_map(plugins)
          @plugin_map ||= {}
          return @plugin_map if @plugin_map.present?

          @will_plugins = []

          use_plugins_info = create_use_plugins_info(plugins)

          loaded_plugins_hooks_map = hooks_map.each_with_object({}) do |(klass, repo), result|
            # MEMO:
            # klass may be DynamicSchema or Plugin or Other Class
            next unless klass.respond_to?(:plugin_name)
            # Plugins that are loaded but not used
            next unless use_plugins_info.keys.include?(klass.plugin_name)

            result[klass.plugin_name] = { klass: klass, repo: repo }
          end

          unknown_plugins = use_plugins_info.keys - loaded_plugins_hooks_map.keys

          raise R2OAS::PluginLoadError, "The '#{unknown_plugins.join(', ')}' plugin doesn't exist or can't be loaded" if unknown_plugins.present?

          loaded_plugins_hooks_map.each do |plugin_name, info|
            plugin_klass = info[:klass]
            repo = info[:repo]

            repo.global_hooks_data.each do |hook_method, callbacks|
              callbacks.each do
                plugin_type = plugin_klass.type

                data = {
                  plugin_name: plugin_name,
                  plugin_klass: plugin_klass,
                  plugin_opts: use_plugins_info[plugin_name],
                  execute_hook_method: "execute_#{hook_method}"
                }

                if @plugin_map[plugin_type].present?
                  if @plugin_map[plugin_type][hook_method].present?
                    @plugin_map[plugin_type][hook_method].push(data)
                  else
                    @plugin_map[plugin_type][hook_method] = [data]
                  end
                else
                  @plugin_map[plugin_type] = {}
                  @plugin_map[plugin_type][hook_method] = [data]
                end
              end
            end
          end

          @plugin_map
        end

        def create_use_plugins_info(plugins)
          will_use_plugins = []
          result = {}

          plugins.each do |plugin_info|
            if plugin_info.is_a?(Array)
              plugin_name = plugin_info[0]
              plugin_opts = plugin_info[1]

              raise PluginNameError, 'Missing plugin name' if plugin_name.blank?

              result[plugin_name] = plugin_opts
            elsif plugin_info.is_a?(String)
              plugin_name = plugin_info
              plugin_opts = nil

              result[plugin_name] = plugin_opts
            else
              raise NoSupportError, "The plugin loading format '#{plugin_info.class}' is incorrect"
            end

            if will_use_plugins.include?(plugin_name)
              raise PluginDuplicationError, "Plugin: duplicate '#{plugin_name}'"
            else
              will_use_plugins.push(plugin_name)
            end
          end

          result
        end
      end
    end
  end
end
