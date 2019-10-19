# frozen_string_literal: true

require 'forwardable'
require 'r2-oas/schema/v3/analyzer'

module RoutesToSwaggerDocs
  module Schema
    class Analyzer
      extend Forwardable

      def_delegators :@analyzer, :analyze_docs

      def initialize(before_schema_data, after_schema_data, options = {})
        case ::RoutesToSwaggerDocs.version
        when :v3
          @analyzer = V3::Analyzer.new(before_schema_data, after_schema_data, options)
        else
          raise NoImplementError, "Do not support version: #{::RoutesToSwaggerDocs.version}"
        end
      end
    end
  end
end
