require_relative '../base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodiesAnalyzer < BaseAnalyzer
        def update_from_schema
          diff_manager = DiffManager.new(@before_schema_data, @after_schema_data)
          diff_manager.process_by_using_diff_data do |request_body_name, is_removed, is_added, after_edited_data|

            dirs = "components/requestBodies"
            filename_with_namespace = request_body_name.split('_').map(&:underscore).join('/')
            save_path = save_path_for(filename_with_namespace, dirs)

            if is_removed && !is_added
              File.delete(save_path) if FileTest.exists?(save_path)
              logger.info "  Delete schema file: \t#{save_path}"
            else
              File.write(save_path, after_edited_data.to_yaml)
              logger.info "  Write schema file: \t#{save_path}"
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
            before_sorted_components_schema         = deep_sort(@before_schema_data["components"], "requestBodies")
            before_components_request_bodies_schema = ensure_presence_or_blank(before_sorted_components_schema["requestBodies"])
            before_request_body_names               = before_components_request_bodies_schema.keys.uniq

            after_sorted_components_schema          = deep_sort(@after_schema_data["components"], "requestBodies")
            after_components_request_bodies_schema  = ensure_presence_or_blank(after_sorted_components_schema["requestBodies"])
            after_request_body_names                = after_components_request_bodies_schema.keys.uniq

            request_body_names = (before_request_body_names + after_request_body_names).uniq

            request_body_names.each do |request_body_name|
              before_filter = Filter.new(before_components_request_bodies_schema, request_body_name)
              after_filter  = Filter.new(after_components_request_bodies_schema, request_body_name)

              before_data = before_filter.only_specify_request_body_names
              after_data  = after_filter.only_specify_request_body_names

              removed, added = before_data.easy_diff(after_data)
              is_removed = to_boolean(removed)
              is_added   = to_boolean(added)

              yield(request_body_name, is_removed, is_added, after_data) if block_given?
            end
          end

          private

          def ensure_presence_or_blank(data)
            data.present? ? data : {}
          end

          def to_boolean(diff)
            if diff.present?
              diff["components"]["requestBodies"].present?
            else
              false
            end
          end
        end

        class Filter
          def initialize(components_request_bodies_schema, request_body_name)
            @components_request_bodies_schema = components_request_bodies_schema
            @request_body_name = request_body_name
          end

          def only_specify_request_body_names
            unit_components_request_bodies = @components_request_bodies_schema.each_with_object({}) do |(request_body, data_when_request_body), result|
              eql_request_body = request_body.eql? @request_body_name
              result.deep_merge!({ "#{request_body}" => data_when_request_body }) if eql_request_body 
            end
            { "components" => { "requestBodies" => unit_components_request_bodies } }
          end
        end
      end
    end
  end
end