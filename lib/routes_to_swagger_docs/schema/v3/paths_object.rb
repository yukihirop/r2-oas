require_relative 'base_object'
require_relative 'path_item_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathsObject < BaseObject
        def initialize(routes_data)
          @routes_data = routes_data
        end
  
        def to_doc
          if unit_paths_file_path.present?
            YAML.load_file(unit_paths_file_path)["paths"]
          else
            path_item_docs.each_with_object({}) do |(path, path_item_doc), docs|
              docs[path] = path_item_doc
            end
          end
        end
  
        private
  
        def path_item_docs
          # e.x.) 
          # [
          #  { path: "/tasks", data: {:verb=>"get", :path=>"/tasks", :tag_name=>"task" } },
          # ]
          @routes_data.each_with_object({}) do |(route_el), data|
            path = route_el[:path]
            route_data = route_el[:data]

            path_item_doc = PathItemObject.new(route_data).to_doc
            if data[path].present?
              data[path].merge!(path_item_doc)
            else
              data[path] = path_item_doc
            end
          end
        end
      end
    end
  end
end