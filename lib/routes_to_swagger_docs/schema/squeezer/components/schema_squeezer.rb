# frozen_string_literal: true

require_relative '../base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemaSqueezer < BaseSqueezer
        def squeeze_docs
          { 'schemas' => @schema_data['components']['schemas'] }
        end
      end
    end
  end
end
