# frozen_string_literal: true

module RoutesToSwaggerDocs
  module AppConfiguration
    class Swagger
      class Editor
        DEFAULT_IMAGE         = 'swaggerapi/swagger-editor'
        DEFAULT_PORT          = '81'
        DEFAULT_EXPOSED_PORT  = '8080/tcp'
        DEFAULT_STORAGE_KEY   = 'swagger-editor-content' # Fixed
        DEFAULT_HOST          = 'http://localhost'       # Fixed

        VALID_OPTIONS_KEYS = %i[
          image
          port
          exposed_port
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

        def storage_key
          DEFAULT_STORAGE_KEY
        end

        private

        def set_default
          self.image         = DEFAULT_IMAGE
          self.port          = DEFAULT_PORT
          self.exposed_port  = DEFAULT_EXPOSED_PORT
        end
      end
    end
  end
end
