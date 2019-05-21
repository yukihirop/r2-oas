#frozen_string_literal: true

module RoutesToSwaggerDocs
  module Configuration
    class Server
      DEFAULT_URL = "http://localhost:3000"
      DEFAULT_DESCRIPTION = "localhost"

      VALID_OPTIONS_KEYS = [
        :url,
        :description
      ]

      attr_accessor *VALID_OPTIONS_KEYS

      def new
        set_default
      end

      def configure
        yield self
      end

      private

      def set_default
        self.url         = DEFAULT_URL
        self.description = DEFAULT_DESCRIPTION
      end
    end
  end
end