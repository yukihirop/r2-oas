require_relative '../base_hash_diff_manager'

module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodyDiffManager < BaseHashDiffManager        
        def initialize(before_schema_data, after_schema_data)
          super
          @major_category  = 'components'
          @middle_category = 'requestBodies'
        end
      end
    end
  end
end
