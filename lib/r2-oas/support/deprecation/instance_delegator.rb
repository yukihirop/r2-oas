# frozen_string_literal: true

require 'forwardable'

# copy from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/deprecation/instance_delegator.rb
module R2OAS
  class Deprecation
    module InstanceDelegator
      # MEMO:
      # base must be singleton class
      def self.included(base)
        base.extend(ClassMethods)
        base.singleton_class.extend(Forwardable)
        base.singleton_class.prepend(OverrideDelegators)
        base.public_class_method :new
      end

      module ClassMethods
        # override Module#include
        def include(included_module)
          included_module.instance_methods.each { |m| method_added(m) }
          super
        end

        def method_added(method_name)
          singleton_class.def_delegators(:instance, method_name)
        end
      end

      module OverrideDelegators
        def warn(message = nil, callstack = nil)
          # MEMO:
          # Why update callstack
          # https://github.com/rails/rails/pull/26686
          callstack ||= caller_locations(2)
          super
        end
        alias will_remove warn
      end
    end
  end
end
