require_relative 'base_component'

module RoutesToSwaggerDocs
  module Routing
    class VerbComponent < BaseComponent
      def initialize(verb)
        @verb = verb
      end

      # e.x.) "" => ["get"]
      # e.x.) "POST" => ["post"]
      # e.x.) "GET|POST" => ["get","post"]
      def verbs
        (@verb.downcase.presence || "get").split("|")
      end
    end
  end
end
