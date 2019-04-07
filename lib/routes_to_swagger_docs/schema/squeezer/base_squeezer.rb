require_relative '../base'

module RoutesToSwaggerDocs
  module Schema
    class BaseSqueezer < Base
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @schema_data = schema_data
        @tag_name = create_tag_name
      end

      private

      attr_accessor :unit_paths_file_path

      def create_tag_name
        paths_from_local = YAML.load_file(@unit_paths_file_path)
        paths_from_local["paths"].values[0].values[0]["tags"][0]
      end
    end
  end
end