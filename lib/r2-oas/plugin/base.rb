# frozen_string_literal: true

require 'r2-oas/base'
require 'r2-oas/hooks/hook'
require_relative 'hookable'

module R2OAS
  module Plugin
    class Base < ::R2OAS::Base
      extend ::R2OAS::Plugin::Hookable

      class << self
        attr_accessor :plugin_name, :type, :opts

        def setup(&block)
          return unless block_given?

          callback = proc { |*args| block.call(*args) }
          on(:setup, callback)
        end

        def teardown(&block)
          return unless block_given?

          callback = proc { |*args| block.call(*args) }
          on(:teardown, callback)
        end

        def execute_setup(*args)
          execute_hook(:setup, *args)
        end

        def execute_teardown(*args)
          execute_hook(:teardown, *args)
        end

        def inherited(base)
          super
          base.opts = {}
        end
      end
    end
  end
end
