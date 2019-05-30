require_relative '../../../schema/v3/base_object'
require_relative '../../../hooks/hook'
require_relative '../../../errors'

module RoutesToSwaggerDocs
  module Plugins
    module Schema
      module V3
        class HookableBaseObject < RoutesToSwaggerDocs::Schema::V3::BaseObject

          def self.inherited(base)
            base.extend ClassMethods
            self.hook = Hooks::Hook.register(base)
            self.hooks = base.hook.repository[base].global_hooks_data
          end

          module ClassMethods
            def before_create(&block)
              proc = (block_given? ? block : Proc.new {})
              on(:before_create, proc)
            end

            def after_create(&block)
              proc = (block_given? ? block : Proc.new {})
              on(:after_create, proc)
            end
          end

          def self.hook=(value); @@hook = value; end
          def self.hook; @@hook; end
          def self.hooks=(value); @@hooks = value; end
          def self.hooks; @@hooks; end

          class << self
            def on(on, callback, once = false)
              hook.on(on, callback, self, once)
            end

            # MEMO: Do not Use
            def off(on, callback, once = false)
              hook.off(on, callback, self, once)
            end

            def execute_hook(on, doc)
              hook.execute_hook(on, doc, self)
            end

            def has_hook?(name)
              hook.has_hook?(name, self)
            end
          end

          attr_accessor :doc

          def initialize(schema_data = {}, options = {})
            super
            self.doc = {}
          end

          def to_doc
            execute_before_create
            create_doc
            execute_after_create
            doc
          end

          private

          def create_doc
            raise NoImplementError
          end

          def execute_before_create
            self.class.execute_hook(:before_create, doc) if self.class.has_hook?(:before_create)
          end

          def execute_after_create
            self.class.execute_hook(:after_create, doc) if self.class.has_hook?(:after_create)
          end
        end
      end
    end
  end
end
