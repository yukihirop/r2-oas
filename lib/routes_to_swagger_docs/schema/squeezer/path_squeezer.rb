# frozen_string_literal: true

require_relative 'base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    class PathSqueezer < BaseSqueezer
      def remake_paths
        slice_paths_schema = @schema_data['paths'].each_with_object({}) do |(path, data_when_path), result|
          data_when_path.values.each do |data_when_verb|
            include_tag_name = data_when_verb['tags'].first.in? @tag_names
            result.deep_merge!(path.to_s => data_when_path) if include_tag_name
          end
        end
        { 'paths' => slice_paths_schema }
      end
    end
  end
end
