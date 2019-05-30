require_relative 'base_object'
require_relative 'path_item_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class TagObject < BaseObject
        def initialize(tags_data)
          @tags_data = tags_data
        end
  
        def to_doc
          @tags_data.each_with_object([]) do |tag_name, result|
            result.push(build_doc(tag_name))
          end
        end
  
        private

        def build_doc(tag_name)
          {
            "name" => tag_name,
            "description" => "#{tag_name} description",
            # External Docs Object
            "externalDocs" => {
              "description" => "description",
              "url" => "url"
            }
          }
        end
      end
    end
  end
end