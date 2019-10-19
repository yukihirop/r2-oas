# frozen_string_literal: true

require_relative 'adjustor'
require_relative 'base'

module RoutesToSwaggerDocs
  module Routing
    class Parser
      # routes should be Rails.application.routes.routes
      def initialize(routes)
        @_routes = routes
        @_engines = {}
      end

      def routes_data
        data = []
        normalized_routes do |route_els|
          data.push *route_els
        end
        data
      end

      def tags_data
        data = []
        normalized_routes do |route_els|
          route_els.each do |route_el|
            tag_name = route_el[:data][:tag_name]
            data.push tag_name unless data.include?(tag_name)
          end
        end
        data
      end

      def schemas_data
        data = []
        normalized_routes do |route_els|
          route_els.each do |route_el|
            schema_name = route_el[:data][:schema_name]
            data.push schema_name unless data.include?(schema_name)
          end
        end
        data
      end

      private

      attr_accessor :_routes, :_engines

      def normalized_routes(&block)
        collect_routes(_routes).each_with_object([]) do |route_data, _arr|
          routes_els = Adjustor.new(route_data).routes_els
          block.call(routes_els) if block_given?
        end
      end

      # copy from:
      # https://github.com/rails/rails/blob/v4.2.1/actionpack/lib/action_dispatch/routing/inspector.rb#L114-L140
      # https://github.com/rails/rails/blob/v5.2.3/actionpack/lib/action_dispatch/routing/inspector.rb
      def collect_routes(routes)
        result = routes.collect do |route|
          ActionDispatch::Routing::RouteWrapper.new(route)
        end.reject(&:internal?).collect do |route|
          collect_engine_routes(route)

          # delete json_regexp after copy
          { route: route,
            name: route.name,
            verb: route.verb,
            path: route.path,
            reqs: route.reqs }
        end

        # Push Rails Engine Routes Data
        _engines.each do |_engine_name, engine_route_data|
          result.push(*engine_route_data)
        end

        result
      end

      # copy from:
      # https://github.com/rails/rails/blob/v4.2.1/actionpack/lib/action_dispatch/routing/inspector.rb#L114-L140
      def collect_engine_routes(route)
        name = route.endpoint
        return unless route.engine?
        return if _engines[name]

        routes = route.rack_app.routes
        _engines[name] = collect_routes(routes.routes) if routes.is_a?(ActionDispatch::Routing::RouteSet)
      end
    end
  end
end
