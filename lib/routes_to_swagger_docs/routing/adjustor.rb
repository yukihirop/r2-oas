require_relative 'base'

module RoutesToSwaggerDocs
  module Routing
    class Adjustor < Base
      VALID_KEYS = %i(route name verb path reqs regexp)

      def initialize(route_data)
        super
        valid_route_data?(route_data)
        @route_data = route_data
        @route = route_data[:route]
        @verbs = create_verbs
        @path = create_path
        @tag_name = create_tag_name
        @format_name = create_format_name
      end

      def routes_els
        verbs.each_with_object([]) do  |verb, result|
          route_el = {}
          route_el[:path] = path
          route_el[:data]= { verb: verb, path: path, tag_name: tag_name, format_name: format_name }
          result.push route_el
        end
      end

      private

      def valid_route_data?(route_data)
        raise RuntimeError,  "Invalid params" unless route_data.keys.eql?(VALID_KEYS)
      end

      attr_accessor :route_data, :route, :verbs, :path, :tag_name, :format_name

      # e.x.) "" => ["get"]
      # e.x.) "POST" => ["post"]
      # e.x.) "GET|POST" => ["get","post"]
      def create_verbs
        (route_data[:verb].downcase.presence || "get").split("|")
      end

      # e.x.) "/tasks(.:format)" => "/tasks"
      def create_path
        route_data[:path].gsub(/\(.+\)/,"")
      end

      # e.x.) "tasks#index" => "task"
      # e.x.) "RailsAdmin::Engine" => "rails_amin/engine"
      def create_tag_name
        tag_name = nil

        if route.engine?
          tag_name = route_data[:reqs].gsub("::","/").underscore
        else
          tag_name = route_data[:reqs].split("#").first.singularize
        end

        unless use_tag_namespace
          tag_name = tag_name.split("/").last
        end

        tag_name
      end

      # e.x.) "tasks#index { :format => ":json" }"
      def create_format_name
        result = ""
        route_data[:reqs].match(/{\:format=>:(?<format_name>.*)}/) do |md|
          result = md[:format_name] if md[:format_name]
        end
        result
      end
    end
  end
end