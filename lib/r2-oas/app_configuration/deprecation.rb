# frozen_string_literal: true

require 'r2-oas/support/deprecation'

module R2OAS
  module AppConfiguration
    class Deprecation
      DEFAULT_SILENCED = ::R2OAS::Deprecation.silenced

      attr_reader :silenced

      def silenced=(value)
        @silenced = !!value
        ::R2OAS::Deprecation.silenced = !!value
      end

      def initialize
        set_default
      end

      private

      def set_default
        self.silenced = DEFAULT_SILENCED
      end
    end
  end
end
