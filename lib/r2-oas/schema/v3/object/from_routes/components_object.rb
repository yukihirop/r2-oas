# frozen_string_literal: true

require_relative 'base_object'
require_relative 'components/schema_object'
require_relative 'components/request_body_object'
require_relative 'path_item_object'

module R2OAS
  module Schema
    module V3
      class ComponentsObject < BaseObject
        def initialize(routes_data, opts = {})
          super(opts)
          @routes_data = routes_data
        end

        def to_doc
          create_doc
          doc
        end

        def create_doc
          create_doc_for_components_schemas!
          create_doc_for_components_request_bodies!
        end

        private

        def create_doc_for_components_schemas!
          result = components_schema_docs.each_with_object({}) do |(schema_name, components_schema_doc), docs|
            docs[schema_name] = components_schema_doc
          end
          doc.merge!({ 'schemas' => result })
        end

        def create_doc_for_components_request_bodies!
          result = components_request_body_docs.each_with_object({}) do |(schema_name, components_request_body_doc), docs|
            docs[schema_name] = components_request_body_doc
          end
          doc.merge!({ 'requestBodies' => result })
        end

        # e.x.)
        # [
        #  { path: "/tasks", data: {:verb=>"get", :path=>"/tasks", :tag_name=>"task" } },
        # ]
        def components_schema_docs
          @routes_data.each_with_object({}) do |(route_el), data|
            path = route_el[:path]
            route_data = route_el[:data]

            path_item_object = PathItemObject.new(route_data, path, @opts)
            path_item_object.http_statuses.each do |http_status|
              components_schema_object = Components::SchemaObject.new(route_data, path, @opts)
              components_schema_doc = components_schema_object.to_doc
              schema_name = components_schema_object.send(:_components_schema_name, http_status)

              if data[schema_name].present?
                data[schema_name].merge!(components_schema_doc)
              else
                data[schema_name] = components_schema_doc
              end
            end
          end
        end

        def components_request_body_docs
          @routes_data.each_with_object({}) do |(route_el), data|
            path = route_el[:path]
            route_data = route_el[:data]

            components_request_body_object = Components::RequestBodyObject.new(route_data, path, @opts)
            next unless components_request_body_object.generate?

            components_request_body_doc = components_request_body_object.to_doc
            schema_name = components_request_body_object.send(:_components_request_body_name)
            if data[schema_name].present?
              data[schema_name].merge!(components_request_body_doc)
            else
              data[schema_name] = components_request_body_doc
            end
          end
        end
      end
    end
  end
end
