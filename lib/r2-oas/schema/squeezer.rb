# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/squeezer'

module R2OAS
  module Schema
    class Squeezer
      extend Forwardable

      def_delegators :@squeezer, :squeeze_docs

      def initialize(schema_data, options = {})
        case ::R2OAS.version
        when :v3
          @squeezer = V3::Squeezer.new(schema_data, options)
        else
          raise NoImplementError, "Do not support version: #{::R2OAS.version}"
        end
      end
    end
  end
end
