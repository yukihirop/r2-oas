# frozen_string_literal: true

require_relative 'base_analyzer'
require 'routes_to_swagger_docs/schema/manager/file_manager'
require 'routes_to_swagger_docs/schema/manager/diff/tag_diff_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class TagAnalyzer < BaseAnalyzer
      def initialize(after_schema_data, options = {})
        super({}, after_schema_data, options)
        @file_manager = FileManager.new('tags', :relative)
        before_schema_data = @file_manager.load_data
        @diff_manager = TagDiffManager.new(before_schema_data, after_schema_data)
      end

      def analyze_docs
        save_file_path = @file_manager.save_file_path
        case @type
        when :edited
          @diff_manager.process_by_using_diff_data do |after_edited_data|
            @file_manager.save(after_edited_data.to_yaml)
            logger.info "  Write schema file: \t#{save_file_path}"
          end
        when :existing
          result = @diff_manager.after_target_data
          @file_manager.save(result.to_yaml)
          logger.info "  Write schema file: \t#{save_file_path}"
        else
          raise NoImplementError
        end
      end
    end
  end
end
