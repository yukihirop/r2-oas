# frozen_string_literal: true

module RoutesToSwaggerDocs
  module AppConfiguration
    class Swagger
      class UI
        DEFAULT_IMAGE        = 'swaggerapi/swagger-ui'
        DEFAULT_PORT         = '8080'
        DEFAULT_EXPOSED_PORT = '8080/tcp'
        DEFAULT_VOLUME       = '/app/swagger.json'
        DEFAULT_HOST         = 'http://localhost' # Fixed

        VALID_OPTIONS_KEYS = %i[
          image
          port
          exposed_port
          volume
        ].freeze

        attr_accessor *VALID_OPTIONS_KEYS

        def initialize
          set_default
        end

        def configure
          yield self
        end

        def url
          "#{DEFAULT_HOST}:#{port}"
        end

        private

        def set_default
          self.image        = DEFAULT_IMAGE
          self.port         = DEFAULT_PORT
          self.exposed_port = DEFAULT_EXPOSED_PORT
          self.volume       = DEFAULT_VOLUME
        end
      end
    end
  end
end
