# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/generator'
require 'pry'

module R2OAS
  module Schema
    class Generator
      extend Forwardable

      def_delegators :@generator, :generate_docs, :swagger_doc

      def initialize(options = {})
        case ::R2OAS.version
        when :v3
          @generator = V3::Generator.new(options)
        else
          raise NoImplementError, "Do not support version: #{::R2OAS.version}"
        end
      end
    end
  end
end
