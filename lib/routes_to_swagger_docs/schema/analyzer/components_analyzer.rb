require_relative './base_analyzer'
require_relative 'components/schemas_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class ComponentsAnalyzer < BaseAnalyzer
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @components_schemas_analyzer = Components::SchemasAnalyzer.new(schema_data, options)
      end

      def update_schema
        edited_components_schema = @edited_schema["components"]
        edited_components_schema.each do |component_type, _|
          case component_type
          when "schemas"
            @components_schemas_analyzer.update_schema
          end
        end
      end
    end
  end
end