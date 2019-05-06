require_relative '../base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class RequestBodiesAnalyzer < BaseAnalyzer
        def update_from_schema
          edited_components_request_bodies_schema = @schema["components"]["requestBodies"]
          edited_request_body_names = edited_components_request_bodies_schema.keys.uniq

          edited_request_body_names.each do |request_body|
            filter = Filter.new(edited_components_request_bodies_schema, request_body)
            unit_schemas_only_specify_request_body_names = filter.only_specify_request_body_names

            dirs = "components/requestBodies"
            filename_with_namespace = request_body.split('_').map(&:underscore).join('/')
            save_path = save_path_for(filename_with_namespace, dirs)
            File.write(save_path, unit_schemas_only_specify_request_body_names.to_yaml)
            logger.info "  Write schema file: \t#{save_path}"
          end
        end

        private

        class Filter
          def initialize(components_request_bodies_schema, request_body)
            @components_request_bodies_schema = components_request_bodies_schema
            @request_body = request_body
          end

          def only_specify_request_body_names
            unit_components_request_bodies = @components_request_bodies_schema.each_with_object({}) do |(request_body, data_when_request_body), result|
              eql_request_body = request_body.eql? @request_body
              result.deep_merge!({ "#{request_body}" => data_when_request_body }) if eql_request_body 
            end
            { "components" => { "requestBodies" => unit_components_request_bodies } }
          end
        end
      end
    end
  end
end