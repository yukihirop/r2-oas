# frozen_string_literal: true

module R2OAS
  module AppConfiguration
    class Server
      DEFAULT_URL = 'http://localhost:3000'
      DEFAULT_DESCRIPTION = 'localhost'

      VALID_OPTIONS_KEYS = [
        :data
      ].freeze

      attr_accessor *VALID_OPTIONS_KEYS

      def initialize
        set_default
      end

      def configure
        yield self
      end

      private

      def set_default
        self.data = [
          {
            url: DEFAULT_URL,
            description: DEFAULT_DESCRIPTION
          }
        ]
      end
    end
  end
end
