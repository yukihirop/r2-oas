# frozen_string_literal: true

require 'r2-oas/plugin/hookable'

module R2OAS
  module Plugin
    module V3
      module Visitable
        include R2OAS::Plugin::Hookable

        SCHEMA_OBJECTS = %i[
          info
          path_item
          external_document
          components_schema
          components_request_body
          components_schema_name
          components_schema_name_at_request_body
          components_request_body_name
        ].freeze

        SCHEMA_OBJECTS.each do |schema_name|
          define_method schema_name.to_s do |&block|
            return if block.blank?

            callback = proc { |*args| block.call(*args) }
            on(schema_name, callback)
          end

          define_method "execute_#{schema_name}" do |*args|
            execute_hook(schema_name, *args)
          end
        end
      end
    end
  end
end
