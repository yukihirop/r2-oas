require_relative '../base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemasAnalyzer < BaseAnalyzer
        def update_schema
          edited_components_schemas_schema = @edited_schema["components"]["schemas"]
          edited_schema_names = edited_components_schemas_schema.keys.uniq

          edited_schema_names.each do |schema_name|
            schema_schema = SchemaSchema.new(edited_components_schemas_schema, schema_name, schema_save_dir_path)
            unit_schemas_only_specify_schema_names = schema_schema.only_specify_schema_names

            dirs = "components/schemas"
            filename_with_namespace = schema_name.split('_').map(&:underscore).join('/')
            save_path = save_path_for(filename_with_namespace, dirs)
            File.write(save_path, unit_schemas_only_specify_schema_names.to_yaml)
          end
        end

        private

        class SchemaSchema
          def initialize(components_schemas_schema, schema_name, schema_save_dir_path)
            @components_schemas_schema = components_schemas_schema
            @schema_name = schema_name
            @schema_save_dir_path = schema_save_dir_path
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