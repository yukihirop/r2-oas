require_relative 'base_squeezer'
require_relative 'components/schema_squeezer'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsSqueezer < BaseSqueezer
      def remake_components
        slice_components_schema = @schema_data["components"].keys.each_with_object({}) do |key, result|
          if key == "schemas"
            options = { unit_paths_file_path: unit_paths_file_path }
            data = Components::SchemaSqueezer.new(@schema_data, options).remake_components_schemas
            result.deep_merge!(data)
          end
        end
        { "components" => slice_components_schema }
      end
    end
  end
end