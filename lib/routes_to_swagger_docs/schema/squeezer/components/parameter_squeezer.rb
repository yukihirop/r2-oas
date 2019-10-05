# frozen_string_literal: true

require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class ParameterSqueezer < BaseSqueezer
        def squeeze_docs
          { 'parameters' => @schema_data['components']['parameters'] }
        end
      end
    end
  end
end
