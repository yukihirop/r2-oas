# frozen_string_literal: true

require_relative 'base_array_diff_manager'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class TagDiffManager < BaseArrayDiffManager
        def initialize(before_schema_data, after_schema_data)
          super
          @major_category  = 'tags'
          @judge_key       = 'name'
        end
      end
    end
  end
end
