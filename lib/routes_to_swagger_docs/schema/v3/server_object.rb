require_relative 'base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class ServerObject < BaseObject
        def to_doc
          server.data.each_with_object([]) do |server, result|
            result.push({
              "url" => "#{server[:url]}",
              "description" => "#{server[:description]}"
            })
            # Do not Server Variable Object
          end
        end
      end
    end
  end
end