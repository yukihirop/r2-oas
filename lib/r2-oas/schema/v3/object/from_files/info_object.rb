# frozen_string_literal: true

require_relative 'base_object'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class InfoObject < BaseObject
          def initialize(doc, opts = {})
            super(opts)
            @doc = doc
          end

          def to_doc
            execute_transform_plugins(:info, @doc)
            @doc
          end
        end
      end
    end
  end
end
