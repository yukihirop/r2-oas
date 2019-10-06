# frozen_string_literal: true

require_relative 'base_hash_diff_manager'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ComponentsDiffManager < BaseHashDiffManager
        def initialize(before_schema_data, after_schema_data, options = {})
          super(before_schema_data, after_schema_data)
          @major_category = 'components'
          @middle_category = options[:middle_category]
          @before_schema_data = normalized(before_schema_data)
          @after_schema_data  = normalized(after_schema_data)
        end
      end
    end
  end
end
