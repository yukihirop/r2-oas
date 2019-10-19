# frozen_string_literal: true

require 'forwardable'
require 'routes_to_swagger_docs/schema/v3/generator'
require 'pry'

module RoutesToSwaggerDocs
  module Schema
    class Generator
      extend Forwardable

      def_delegators :@generator, :generate_docs, :swagger_doc

      def initialize(options = {})
        case ::RoutesToSwaggerDocs.version
        when :v3
          @generator = V3::Generator.new(options)
        else
          raise NoImplementError, "Do not support version: #{::RoutesToSwaggerDocs.version}"
        end
      end
    end
  end
end
