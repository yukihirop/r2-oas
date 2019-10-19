# frozen_string_literal: true

require_relative 'base_squeezer'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathSqueezer < BaseSqueezer
        VERB = %w[get put post delete options head patch trace].freeze
        NOT_VERB = %w[$ref summary description servers parameters].freeze

        def squeeze_docs
          slice_paths_schema = @schema_data['paths'].each_with_object({}) do |(path, data_when_path), result|
            data_when_path.each do |verb_or_not, data_when_verb_or_not|
              if VERB.include?(verb_or_not)
                include_tag_name = data_when_verb_or_not['tags'].first.in? @tag_names
                result.deep_merge!(path.to_s => data_when_path) if include_tag_name
              elsif NOT_VERB.include?(verb_or_not)
                result.deep_merge!(path.to_s => data_when_path)
              end
            end
          end
          { 'paths' => slice_paths_schema }
        end
      end
    end
  end
end
