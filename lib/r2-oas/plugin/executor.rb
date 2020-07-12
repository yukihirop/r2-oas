# frozen_string_literal: true

require_relative 'hookable'
require 'r2-oas/errors'

module R2OAS
  module Plugin
    class Executor
      extend ::R2OAS::Plugin::Hookable

      def initialize(plugins)
        @plugins = plugins
      end

      def execute_transform_plugins(hook_method, *args)
        self.class.execute_transform_plugins(@plugins, hook_method, *args)
      end

      def execute_plugins(type, hook_method, *args)
        self.class.execute_plugins(@plugins, type, hook_method, *args)
      end

      class << self
        def execute_transform_plugins(plugins, hook_method, *args)
          execute_plugins(plugins, :transform, hook_method, *args)
        end

        def execute_plugins(plugins, type, hook_method, *args)
          return unless plugin_map(plugins).present?

          plugins_info = plugin_map(plugins)[type.to_sym][hook_method.to_sym]

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
          @used_plugins ||= []
          @result ||= {}
          return @result if @result.present?

          plugins.each do |plugin_info|
            plugin_name = plugin_info[0]
            plugin_opts = plugin_info[1]

            if @used_plugins.include?(plugin_name)
              raise PluginDuplicationError, "Plugin: duplicate '#{plugin_name}'"
            else
              @used_plugins.push(plugin_name)
            end

            hooks_map.each do |klass, repo|
              # MEMO:
              # klass may be DynamicSchema or Plugin or Other Class
              if !klass.respond_to?(:plugin_name)
                next
              elsif !plugins_list(plugins).include?(klass.plugin_name) && klass.plugin_name != plugin_name
                raise PluginLoadError, "The '#{plugin_name}' plugin doesn't exist or can't be loaded." if klass.plugin_name.present?

                next
              # else
                # MEMO:
                # At this point, it cannot be determined that a plugin class is a valid plugin class just
                # because the plugin name is different from the one defined in the loaded plugin class.
              end

              # MEMO:
              # If you can reach this point, you're in the Plug-in class.
              plugin_klass = klass

              repo.global_hooks_data.each do |hook_method, callbacks|
                callbacks.each do
                  next if plugin_klass.plugin_name != plugin_name

                  plugin_type = plugin_klass.type
                  data = {
                    plugin_name: plugin_name,
                    plugin_klass: plugin_klass,
                    plugin_opts: plugin_opts,
                    execute_hook_method: "execute_#{hook_method}"
                  }

                  if @result[plugin_type].present?
                    if @result[plugin_type][hook_method].present?
                      @result[plugin_type][hook_method].push(data)
                    else
                      @result[plugin_type][hook_method] = [data]
                    end
                  else
                    @result[plugin_type] = {}
                    @result[plugin_type][hook_method] = [data]
                  end
                end
              end
            end
          end
          @result
        end

        def plugins_list(plugins)
          plugins.map { |plugin_info| plugin_info[0] }
        end
      end
    end
  end
end