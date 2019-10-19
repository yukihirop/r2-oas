# frozen_string_literal: true

require 'singleton'
require_relative './global_hook'
require_relative './repository'

module RoutesToSwaggerDocs
  module Hooks
    class Hook
      include Singleton

      class << self
        attr_accessor :repository

        def register(target_class)
          @repository ||= {}
          @hooks ||= {}
          @repository[target_class] = Repository.new(target_class)
          self
        end

        def on(on, callback, target_class, once = false)
          target_repository = @repository[target_class]
          uid = target_repository.last_hook_id + 1
          target_repository.last_hook_id = uid

          @repository[target_class].global_hooks_data[on] ||= []
          global_hook = GlobalHook.new(callback, once, uid, target_class)

          target_repository.global_hooks_data[on].push(global_hook)

          uid
        end

        #  MEMO: Do not Use
        def off(uid, target_class)
          target_repository = @repository[target_class]
          result = uid

          target_repository.global_hooks_data.each do |on|
            global_hooks = target_repository.global_hooks_data[on]
            index = global_hooks.find_index { |hook| hook.uid == uid }

            if index
              global_hooks.delete_if { |hook| hook.uid == uid }
            else
              result = nil
            end
          end

          result
        end

        def execute_hook(on, *data, target_class)
          return data unless has_hook?(on, target_class)

          execute_global_hook(on, *data, target_class)
        end

        def has_hook?(name, target_class)
          !!get_hook(name, target_class)
        end

        private

        def execute_global_hook(on, *data, target_class)
          global_hook = get_hook(on, target_class)
          global_hook.present? ? global_hook.call(*data) : data
        end

        def get_hook(name, target_class)
          target_class.hooks[name]&.first
        end
      end
    end
  end
end
