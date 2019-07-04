# frozen_string_literal: true

require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodySqueezer < BaseSqueezer
        def squeeze_docs
          { 'requestBodies' => @schema_data['components']['requestBodies'] }
        end
      end
    end
  end
end
