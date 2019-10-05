# frozen_string_literal: true

require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class SecuritySchemeSqueezer < BaseSqueezer
        def squeeze_docs
          { 'securitySchemes' => @schema_data['components']['securitySchemes'] }
        end
      end
    end
  end
end
