# frozen_string_literal: true

require 'r2-oas/hooks/hook'

module R2OAS
  module Plugin
    module Hookable
      def self.extended(base)
        super
        base.class_variable_set(:@@hook_klass, ::R2OAS::Hooks::Hook.register(:plugin, base))
      end

      def hooks_map
        hook_klass.repository[:plugin]
      end

      def hooks
        hooks_map[self].global_hooks_data
      end

      def hook_klass=(klass)
        class_variable_set(:@@hook_klass, klass)
      end

      def hook_klass
        class_variable_get(:@@hook_klass)
      end

      def on(on, callback, once = false)
        hook_klass.on(on, callback, self, once)
      end

      # MEMO: Do not Use
      def off(on, callback, once = false)
        hook_klass.off(on, callback, self, once)
      end

      def execute_hook(on, *data)
        hook_klass.execute_hook(on, *data, self)
      end

      def has_hook?(name)
        hook_klass.has_hook?(name, self)
      end
    end
  end
end
