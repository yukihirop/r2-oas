# frozen_string_literal: true

require_relative '../base'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module V3
      class Base < ::RoutesToSwaggerDocs::Schema::Base
        SUPPORT_COMPONENTS_OBJECTS = %w[
          schemas
          requestBodies
          securitySchemes
          parameters
          responses
          examples
          headers
          links
          callbacks
        ].freeze

        def support_components_objects
          SUPPORT_COMPONENTS_OBJECTS
        end
      end
    end
  end
end
