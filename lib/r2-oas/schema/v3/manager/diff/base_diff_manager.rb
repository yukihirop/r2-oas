# frozen_string_literal: true

require 'easy_diff'
require 'r2-oas/schema/v3/base'

module R2OAS
  module Schema
    module V3
      class BaseDiffManager < Base
        include Sortable

        def initialize(before_schema_data, after_schema_data)
          @before_schema_data = before_schema_data
          @after_schema_data  = after_schema_data
        end

        def process_by_using_diff_data
          raise NoImplementError, 'Please implement in inherited class.'
        end

        private

        def ensure_presence_or_blank(data)
          data.present? ? data : {}
        end
      end
    end
  end
end
