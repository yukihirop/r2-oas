# frozen_string_literal: true

require_relative 'base_builder'
require_relative 'components/object_builder'
require_relative 'components/request_body_builder'

module R2OAS
  module Schema
    module V3
      class ComponentsBuilder < BaseBuilder
        def initialize(schema_data = {}, options = {})
          super(options)
          @components = schema_data['components'] || scehma_data[:components]
          @options = options
        end

        def build_docs
          support_components_objects.each do |object_name|
            builder_class(object_name).new(@components, @options.merge(
                                                          middle_category: object_name
                                                        )).build_docs
          end
        end

        private

        def builder_class(object_name)
          case object_name
          when 'requestBodies'
            Components::RequestBodyBuilder
          else
            Components::ObjectBuilder
          end
        end
      end
    end
  end
end
