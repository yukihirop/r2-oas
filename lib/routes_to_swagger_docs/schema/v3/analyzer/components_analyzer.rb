# frozen_string_literal: true

require_relative 'base_analyzer'
require_relative 'components/object_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class ComponentsAnalyzer < BaseAnalyzer
      def initialize(before_schema_data, after_schema_data, options = {})
        super
        @options = options
      end      

      def analyze_docs
        support_components_objects.each do |object_name|
          logger.info "[Analyze Swagger file (components/#{object_name})] start"
          Components::ObjectAnalyzer.new(
            @before_schema_data, 
            @after_schema_data, 
            @options.merge({ middle_category: object_name })
          ).analyze_docs
          logger.info "[Analyze Swagger file (components/#{object_name})] end"
        end
      end
    end
  end
end
