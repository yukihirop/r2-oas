# frozen_string_literal: true

require_relative 'base_component'

module RoutesToSwaggerDocs
  module Routing
    class RequestComponent < BaseComponent
      def initialize(request, is_route_engine)
        super()
        @request = request
        @is_route_engine = is_route_engine
      end

      # e.x.) "tasks#index" => "task"
      # e.x.) "RailsAdmin::Engine" => "rails_amin/engine"
      def to_tag_name
        tag_name = if @is_route_engine
                     @request.gsub('::', '/').underscore
                   else
                     @request.split('#').first.singularize
                   end

        tag_name = tag_name.split('/').last unless use_tag_namespace

        tag_name
      end

      def to_schema_name
        if @is_route_engine
          schema_name = @request.split('::').map(&:camelcase).join('_')
        else
          # e.x.) @request = "api/v2/posts#index {:format=>:json}"
          # e.x.) path = "api/v2/post"
          path = @request.split('#').first.singularize
          schema_name = path.split('/').map(&:camelcase).join('_')
        end

        schema_name = schema_name.split('_').last unless use_schema_namespace

        schema_name
      end

      # e.x.) "tasks#index { :format => ":json" }"
      def to_format_name
        result = ''
        @request.match(/{\:format=>:(?<format_name>.*)}/) do |md|
          result = md[:format_name] if md[:format_name]
        end
        result
      end
    end
  end
end
