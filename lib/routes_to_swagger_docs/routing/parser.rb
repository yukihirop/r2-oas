module RoutesToSwaggerDocs
  module Routing
    class Parser
      VALID_KEYS = %i(name verb path reqs regexp)

      attr_accessor :routes_data, :tags_data

      # routes should be Rails.application.routes.routes
      def initialize(routes)
        @_routes = routes
      end

      def routes_data
        data = []
        normalized_routes do |route_el|
          data.push route_el
        end
        data
      end

      def tags_data
        data = []
        normalized_routes do |route_el|
          tag_name = route_el[:data][:tag_name]
          unless data.include?(tag_name)
            data.push tag_name
          end
        end
        data
      end
  
      private

      attr_accessor :_routes

      def normalized_routes(&block)
        collect_routes(_routes).each_with_object([]) do |route_data, arr|
          valid_route_data?(route_data)

          verb = route_data[:verb].downcase
          # e.x.) "/tasks(.:format)" => "/tasks"
          path = route_data[:path].gsub(/\(.+\)/,"") 
          # e.x.) "tasks#index" => "task"
          tag_name = route_data[:reqs].split("#").first.singularize
          # e.x.) "tasks#index { :format => ":json" }"
          format_name = ""
          route_data[:reqs].match(/{\:format=>:(?<format_name>.*)}/) do |md|
            format_name = md[:format_name] if md[:format_name]
          end

          route_el = {}
          route_el[:path] = path
          route_el[:data]= { verb: verb, path: path, tag_name: tag_name, format_name: format_name }

          block.call(route_el) if block_given?
        end
      end

      def valid_route_data?(route_data)
        raise RuntimeError,  "Invalid params" unless route_data.keys.eql? VALID_KEYS
      end
  
      # copy from:
      # https://github.com/rails/rails/blob/v4.2.1/actionpack/lib/action_dispatch/routing/inspector.rb#L114-L140
      def collect_routes(routes)
        routes.collect do |route|
          ActionDispatch::Routing::RouteWrapper.new(route)
        end.reject do |route|
          route.internal?
        end.collect do |route|
          collect_engine_routes(route)
  
          { name:   route.name,
            verb:   route.verb,
            path:   route.path,
            reqs:   route.reqs,
            regexp: route.json_regexp }
        end
      end
  
      def collect_engine_routes(route)
        name = route.endpoint
        return unless route.engine?
        return if @engines[name]
  
        routes = route.rack_app.routes
        if routes.is_a?(ActionDispatch::Routing::RouteSet)
          @engines[name] = collect_routes(routes.routes)
        end
      end
    end
  end
end