# frozen_string_literal: true

module R2OAS
  module Hooks
    class GlobalHook
      attr_accessor :callback, :once, :uid, :target

      def initialize(callback, once, uid, target)
        self.callback = callback
        self.once = once
        self.uid = uid
        self.target = target
      end

      def call(*data)
        callback.call(*data)
      end
    end
  end
end
