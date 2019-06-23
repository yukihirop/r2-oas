require_relative '../../plugins/schema/v3/hookable_base_object'
require_relative 'components/schema_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ComponentsObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        def initialize(routes_data)
          super(routes_data)
          @routes_data = routes_data
        end

        def create_doc
          result = components_schema_docs.each_with_object({}) do |(schema_name, components_schema_doc), docs|
            docs[schema_name] = components_schema_doc
          end
          doc.merge!({ "schemas" => result })
        end

        private

        # e.x.) 
        # [
        #  { path: "/tasks", data: {:verb=>"get", :path=>"/tasks", :tag_name=>"task" } },
        # ]
        def components_schema_docs
          @routes_data.each_with_object({}) do |(route_el), data|
            path        = route_el[:path]
            route_data  = route_el[:data]

            path_item_object = path_item_object_class.new(route_data, path)
            path_item_object.http_statuses.each do |http_status|
              schema_name = path_item_object.send(:_components_schema_name, http_status)

              components_schema_doc = Components::SchemaObject.new(schema_name).to_doc
              if data[schema_name].present?
                data[schema_name].merge!(components_schema_doc)
              else
                data[schema_name] = components_schema_doc
              end
            end
          end
        end
      end
    end
  end
end