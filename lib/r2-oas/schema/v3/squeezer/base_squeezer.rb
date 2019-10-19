# frozen_string_literal: true

module RoutesToSwaggerDocs
  module Schema
    module V3
      class BaseSqueezer < Base
        def initialize(schema_data, options = {})
          super(options)
          @schema_data = schema_data
          @tag_names = create_tag_names
        end

        def squeeze_docs
          raise NoImplementError, 'Please implement in inherited class.'
        end

        private

        attr_accessor :many_paths_file_paths

        def create_tag_names
          many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
            paths_from_local = YAML.load_file(unit_paths_path)

            tag_name_from_path = if paths_from_local['paths'].values[0].values[0].is_a?(Array)
                                   'unknown'
                                 else
                                   paths_from_local['paths'].values[0].values[0]['tags'][0]
                                 end

            result.push(tag_name_from_path)
          end
        end
      end
    end
  end
end
