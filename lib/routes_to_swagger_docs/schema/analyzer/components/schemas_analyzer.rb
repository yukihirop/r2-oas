require_relative '../base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemasAnalyzer < BaseAnalyzer
        def update_from_schema
          edited_components_schemas_schema = @schema["components"]["schemas"]
          edited_schema_names = edited_components_schemas_schema.keys.uniq

          edited_schema_names.each do |schema_name|
            filter = Filter.new(edited_components_schemas_schema, schema_name)
            unit_schemas_only_specify_schema_names = filter.only_specify_schema_names

            dirs = "components/schemas"
            filename_with_namespace = schema_name.split('_').map(&:underscore).join('/')
            save_path = save_path_for(filename_with_namespace, dirs)
            File.write(save_path, unit_schemas_only_specify_schema_names.to_yaml)
            logger.info "  Write schema file: \t#{save_path}"
          end
        end

        private

        class Filter
          def initialize(components_schemas_schema, schema_name)
            @components_schemas_schema = components_schemas_schema
            @schema_name = schema_name
          end

          def only_specify_schema_names
            unit_components_schemas = @components_schemas_schema.each_with_object({}) do |(schema_name, data_when_schema), result|
              eql_schema_name = schema_name.eql? @schema_name
              result.deep_merge!({ "#{schema_name}" => data_when_schema }) if eql_schema_name 
            end
            { "components" => { "schemas" => unit_components_schemas } }
          end
        end
      end
    end
  end
end