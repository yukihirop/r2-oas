require_relative 'base_component'

module RoutesToSwaggerDocs
  module Routing
    class RequestComponent < BaseComponent
      def initialize(request, is_route_engine)
        @request = request
        @is_route_engine = is_route_engine
      end

      # e.x.) "tasks#index" => "task"
      # e.x.) "RailsAdmin::Engine" => "rails_amin/engine"
      def to_tag_name
        if @is_route_engine
          tag_name = @request.gsub("::","/").underscore
        else
          tag_name = @request.split("#").first.singularize
        end

        unless use_tag_namespace
          tag_name = tag_name.split("/").last
        end

        tag_name
      end
    end
  end
end