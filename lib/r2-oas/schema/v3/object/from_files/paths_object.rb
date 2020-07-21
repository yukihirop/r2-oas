# frozen_string_literal: true

require_relative 'base_object'
require_relative 'path_item_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class PathsObject < BaseObject
          def initialize(doc, opts = {})
            super(opts)
            @doc = doc
          end

          def to_doc
            create_doc
            @doc
          end

          private

          def create_doc
            @doc.each do |path, doc_when_path|
              ref = { path: path }
              @doc[path] = PathItemObject.new(doc_when_path, ref, opts).to_doc
            end
          end
        end
      end
    end
  end
end
