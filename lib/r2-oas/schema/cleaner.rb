# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/cleaner'

module R2OAS
  module Schema
    class Cleaner
      extend Forwardable

      def_delegators :@cleaner, :clean_docs

      def initialize(options = {})
        case ::R2OAS.version
        when :v3
          @cleaner = V3::Cleaner.new(options)
        else
          raise NoImplementError, "Do not support version: #{::R2OAS.version}"
        end
      end
    end
  end
end
