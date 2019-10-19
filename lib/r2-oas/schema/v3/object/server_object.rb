# frozen_string_literal: true

require_relative 'base_object'

module R2OAS
  module Schema
    module V3
      class ServerObject < BaseObject
        def to_doc
          server.data.each_with_object([]) do |server, result|
            result.push(
              'url' => (server[:url]).to_s,
              'description' => (server[:description]).to_s
            )
            # Do not Server Variable Object
          end
        end
      end
    end
  end
end
