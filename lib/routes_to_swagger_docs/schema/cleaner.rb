# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/cleaner'

module RoutesToSwaggerDocs
  module Schema
    class Cleaner
      extend Forwardable

      def_delegators :@cleaner, :clean_docs

      def initialize(options = {})
        case ::RoutesToSwaggerDocs.version
        when :v3
          @cleaner = V3::Cleaner.new(options)
        else
          raise NoImplementError, "Do not support version: #{::RoutesToSwaggerDocs.version}"
        end
      end
    end
  end
end
