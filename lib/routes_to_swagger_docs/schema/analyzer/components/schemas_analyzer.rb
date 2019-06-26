require_relative '../base_analyzer'
require_relative '../../manager/file/components/schema_file_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class SchemasAnalyzer < BaseAnalyzer
        def update_from_schema
          diff_manager = DiffManager.new(@before_schema_data, @after_schema_data)
          diff_manager.process_by_using_diff_data do |schema_name, is_removed, is_added, after_edited_data|
            
            file_manager = Components::SchemaFileManager.new("components/schemas/#{schema_name}", :relative)
            save_file_path = file_manager.save_file_path

            if is_removed && !is_added
              file_manager.delete
              logger.info "  Delete schema file: \t#{save_file_path}"
            else
              file_manager.save(after_edited_data.to_yaml)
              logger.info "  Write schema file: \t#{save_file_path}"
            end
          end
        end

        private

        class DiffManager
          include Sortable

          def initialize(before_schema_data, after_schema_data)
            @before_schema_data = before_schema_data
            @after_schema_data  = after_schema_data
          end

          def process_by_using_diff_data(&block)
            before_sorted_components_schema  = deep_sort(@before_schema_data["components"], "schemas")
            before_components_schemas_schema = ensure_presence_or_blank(before_sorted_components_schema["schemas"])
            before_schema_names              = before_components_schemas_schema.keys.uniq

            after_sorted_components_schema   = deep_sort(@after_schema_data["components"], "schemas")
            after_components_schemas_schema  = ensure_presence_or_blank(after_sorted_components_schema["schemas"])
            after_schema_names               = after_components_schemas_schema.keys.uniq

            edited_schema_names = (before_schema_names + after_schema_names).uniq
            
            edited_schema_names.each do |schema_name|
              before_filter = Filter.new(before_components_schemas_schema, schema_name)
              after_filter = Filter.new(after_components_schemas_schema, schema_name)

              before_data = before_filter.only_specify_schema_names
              after_data = after_filter.only_specify_schema_names

              removed, added = before_data.easy_diff(after_data)
              is_removed = to_boolean(removed)
              is_added   = to_boolean(added)

              yield(schema_name, is_removed, is_added, after_data) if block_given?
            end
          end

          private

          def ensure_presence_or_blank(data)
            data.present? ? data : {}
          end

          def to_boolean(diff)
            if diff.present?
              diff["components"]["schemas"].present?
            else
              false
            end
          end
        end

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