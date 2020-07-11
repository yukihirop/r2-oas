# frozen_string_literal: true

require_relative 'visitable'
require 'r2-oas/plugin/base'

module R2OAS
  module Plugin
    module V3
      class Transform < ::R2OAS::Plugin::Base
        extend Visitable

        def self.inherited(base)
          super
          self.hook_klass = ::R2OAS::Hooks::Hook.register(base)
          base.type = :transform
        end
      end
    end
  end
end
