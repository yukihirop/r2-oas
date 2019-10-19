# frozen_string_literal: true

module R2OAS
  module Hooks
    class Repository
      attr_accessor :global_hooks_data, :last_hook_id, :target

      def initialize(target)
        @global_hooks_data = {}
        @last_hook_id = 0
        @target = target
      end
    end
  end
end
