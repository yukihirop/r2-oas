# frozen_string_literal: true

require_relative '../../../schema/v3/base_object'
require_relative '../../../hooks/hook'
require_relative '../../../errors'

module RoutesToSwaggerDocs
  module Plugins
    module Schema
      module V3
        class HookableBaseObject < RoutesToSwaggerDocs::Schema::V3::BaseObject
          module ClassMethods
            def before_create(&block)
              proc = (block_given? ? block : proc {})
              on(:before_create, proc)
            end

            def after_create(&block)
              proc = (block_given? ? block : proc {})
              on(:after_create, proc)
            end
          end

          def self.inherited(base)
            base.extend ClassMethods
            self.hook = Hooks::Hook.register(base)
          end

          def self.hooks
            superclass.hook.repository[self].global_hooks_data
          end

          def self.hook=(value)
            @@hook = value
          end

          def self.hook
            @@hook
          end

          class << self
            def on(on, callback, once = false)
              hook.on(on, callback, self, once)
            end

            # MEMO: Do not Use
            def off(on, callback, once = false)
              hook.off(on, callback, self, once)
            end

            def execute_hook(on, *data)
              hook.execute_hook(on, *data, self)
            end

            def has_hook?(name)
              hook.has_hook?(name, self)
            end
          end

          attr_accessor :doc

          def initialize
            super
            self.doc = {}
          end

          # MEMO: Please overwrite when passing arguments other than `doc`
          def to_doc
            execute_before_create
            create_doc
            execute_after_create
            doc
          end

          def use_superclass_hook
            self.class.hook.repository[self.class] = self.class.hook.repository[self.class.superclass]
          end

          private

          def create_doc
            raise NoImplementError
          end

          def execute_before_create(*data)
            execute_hook_method(:before_create, *data)
          end

          def execute_after_create(*data)
            execute_hook_method(:after_create, *data)
          end

          def execute_hook_method(method_name, *data)
            args = [doc].push(*data)
            self.class.execute_hook(method_name.to_sym, *args) if self.class.has_hook?(method_name.to_sym)
          end
        end
      end
    end
  end
end
