# frozen_string_literal: true

require_relative 'analyzer/base_analyzer'
require_relative 'analyzer/path_analyzer'
require_relative 'analyzer/tag_analyzer'
require_relative 'analyzer/components_analyzer'
require 'r2-oas/schema/v3/manager/file_manager'

module R2OAS
  module Schema
    module V3
      class Analyzer < BaseAnalyzer
        def initialize(before_schema_data, after_schema_data, options = {})
          super
          @path_analyzer       = PathAnalyzer.new(@before_schema_data, @after_schema_data, options)
          @tag_analyzer        = TagAnalyzer.new(@after_schema_data, options)
          @components_analyzer = ComponentsAnalyzer.new(@before_schema_data, @after_schema_data, options)
        end

        def analyze_docs
          logger.info '[Analyze OAS file] start'
          @after_schema_data.keys.each do |schema_name|
            case schema_name
            when 'paths'
              logger.info '[Analyze OAS file (paths)] start'
              @path_analyzer.analyze_docs
              logger.info '[Analyze OAS file (paths)] end'
            when 'tags'
              logger.info '[Analyze OAS file (tags)] start'
              @tag_analyzer.analyze_docs
              logger.info '[Analyze OAS file (tags)] end'
            when 'components'
              logger.info '[Analyze OAS file (components)] start'
              @components_analyzer.analyze_docs
              logger.info '[Analyze OAS file (components)] end'
            else
              save_schema_when(schema_name)
            end
          end
          logger.info '[Analyze OAS file] end'
        end

        private

        def save_schema_when(schema_name)
          file_manager = FileManager.new(schema_name, :relative)
          data = @after_schema_data.slice(schema_name)
          case @type
          when :edited
            file_manager.save_after_deep_merge(data)
          when :existing
            file_manager.save(data.to_yaml)
          end
        end
      end
    end
  end
end
