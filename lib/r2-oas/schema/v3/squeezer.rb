# frozen_string_literal: true

require_relative 'squeezer/base_squeezer'
require_relative 'squeezer/tag_squeezer'
require_relative 'squeezer/path_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class Squeezer < BaseSqueezer
        def squeeze_docs
          except_paths_schema = @schema_data.except('paths', 'tags', 'components')
          components_schemas = @schema_data.slice('components')

          path_squeezer = PathSqueezer.new(@schema_data, many_paths_file_paths: many_paths_file_paths)
          tag_squeezer = TagSqueezer.new(@schema_data, many_paths_file_paths: many_paths_file_paths)

          # To make components merge after paths
          slice_schemas = [
            tag_squeezer.squeeze_docs,
            path_squeezer.squeeze_docs,
            components_schemas
          ]
          slice_schemas.each_with_object(except_paths_schema) { |slice_schema, result| result.deep_merge!(slice_schema) }
        end
      end
    end
  end
end
