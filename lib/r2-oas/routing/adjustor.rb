# frozen_string_literal: true

require_relative 'base'
require_relative 'components/all'

module R2OAS
  module Routing
    class Adjustor < Base
      VALID_KEYS = %i[route name verb path reqs].freeze

      def initialize(route_data)
        valid_route_data?(route_data)
        @route_data = route_data
        @route = route_data[:route]
        @path_comp = PathComponent.new(route_data[:path])
        @request_comp = RequestComponent.new(route_data[:reqs], @route.engine?)
        @verb_comp = VerbComponent.new(route_data[:verb])
        @verbs = @verb_comp.verbs
      end

      def routes_els
        @verbs.each_with_object([]) do |verb, result|
          route_el = {}
          route_el[:path] = @path_comp.symbol_to_brace
          route_el[:data] = {
            verb: verb,
            path: @path_comp.symbol_to_brace,
            tag_name: @request_comp.to_tag_name,
            schema_name: @request_comp.to_schema_name,
            format_name: @request_comp.to_format_name,
            required_parameters: @path_comp.path_parameters_data
          }
          result.push route_el
        end
      end

      private

      def valid_route_data?(route_data)
        raise 'Invalid params' unless route_data.keys.eql?(VALID_KEYS)
      end
    end
  end
end
