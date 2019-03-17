require_relative 'base_object'
require_relative 'path_item_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class TagObject < BaseObject
        def initialize(tag_name)
          @name = tag_name
        end
  
        def to_doc
          {
            "name" => name,
            "description" => "#{name} description",
            # External Docs Object
            "externalDocs" => {
              "description" => "description",
              "url" => "url"
            }
          }
        end
  
        private
        
        attr_accessor :name
      end
    end
  end
end