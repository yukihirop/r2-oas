# frozen_string_literal: true

# MEMO:
# copy from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/deprecation/behaviors.rb
module R2OAS
  class Deprecation
    class DeprecationError < StandardError; end

    DEFAULT_BEHAVIORS = {
      stderr: lambda { |message, _callstack, _deprecation_horizon, _gem_name|
        $stderr.puts(message)
      }
    }.freeze

    module Behavior
      def behavior
        @behavior ||= [DEFAULT_BEHAVIORS[:stderr]]
      end
    end
  end
end
