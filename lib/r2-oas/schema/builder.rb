# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/builder'

module R2OAS
  module Schema
    class Builder
      extend Forwardable

      def_delegators :@builder, :build_docs, :oas_doc, :pure_oas_doc

      def initialize(options = {})
        case ::R2OAS.version
        when :v3
          @builder = V3::Builder.new(options)
        else
          raise NoImplementError, "Do not support version: #{::R2OAS.version}"
        end
      end
    end
  end
end
