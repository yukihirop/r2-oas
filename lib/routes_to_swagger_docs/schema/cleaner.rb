# frozen_string_literal: true

require 'forwardable'
require 'routes_to_swagger_docs/schema/v3/cleaner'

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
          raise "Do not support version: #{version}"
        end
      end
    end
  end
end
