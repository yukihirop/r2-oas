require_relative 'base'
require_relative 'components/path_component'

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
        @path_comp = PathComponent.new(route_data[:path])
        @tag_name = create_tag_name
        @schema_name = create_schema_name
        @format_name = create_format_name
      end

      def routes_els
        @verbs.each_with_object([]) do  |verb, result|
          route_el = {}
          route_el[:path] = @path_comp.symbol_to_brace
          route_el[:data]= {
            verb: verb,
            path: @path_comp.symbol_to_brace,
            tag_name: @tag_name,
            schema_name: @schema_name,
            format_name: @format_name,
            required_parameters: @path_comp.path_parameters_data
          }
          result.push route_el
        end
      end

      private

      def valid_route_data?(route_data)
        raise RuntimeError,  "Invalid params" unless route_data.keys.eql?(VALID_KEYS)
      end

      # e.x.) "" => ["get"]
      # e.x.) "POST" => ["post"]
      # e.x.) "GET|POST" => ["get","post"]
      def create_verbs
        (@route_data[:verb].downcase.presence || "get").split("|")
      end

      # e.x.) "tasks#index" => "task"
      # e.x.) "RailsAdmin::Engine" => "rails_amin/engine"
      def create_tag_name
        tag_name = nil

        if @route.engine?
          tag_name = @route_data[:reqs].gsub("::","/").underscore
        else
          tag_name = @route_data[:reqs].split("#").first.singularize
        end

        unless use_tag_namespace
          tag_name = tag_name.split("/").last
        end

        tag_name
      end

      def create_schema_name
        schema_name = nil

        if @route.engine?
          schema_name = @route_data[:reqs].split("::").map(&:camelcase).join("_")
        else
          # e.x.) @route_data[:reqs] = "api/v2/posts#index {:format=>:json}"
          # e.x.) path = "api/v2/post"
          path = @route_data[:reqs].split("#").first.singularize
          schema_name = path.split("/").map(&:camelcase).join("_")
        end

        unless use_schema_namespace
          schema_name = schema_name.split("_").last
        end

        schema_name
      end

      # e.x.) "tasks#index { :format => ":json" }"
      def create_format_name
        result = ""
        @route_data[:reqs].match(/{\:format=>:(?<format_name>.*)}/) do |md|
          result = md[:format_name] if md[:format_name]
        end
        result
      end
    end
  end
end
