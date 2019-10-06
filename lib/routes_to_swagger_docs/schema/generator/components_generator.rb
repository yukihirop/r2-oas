# frozen_string_literal: true

require_relative 'base_generator'
require_relative 'components/object_generator'
require_relative 'components/request_body_generator'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(options)
        @components = schema_data['components'] || scehma_data[:components]
        @options = options
      end

      def generate_docs
        support_components_objects.each do |object_name|
          generator_class(object_name).new(@components, @options.merge({
            middle_category: object_name
          })).generate_docs
        end
      end

      private

      def generator_class(object_name)
        case object_name
        when 'requestBodies'
          Components::RequestBodyGenerator
        else
          Components::ObjectGenerator
        end
      end
    end
  end
end
