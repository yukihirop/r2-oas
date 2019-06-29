# frozen_string_literal: true

require_relative 'base_analyzer'
require_relative '../manager/file_manager'
require_relative '../manager/diff/tag_diff_manager'
require_relative '../../errors'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class TagAnalyzer < BaseAnalyzer
      def initialize(before_schema_data, after_schema_data = {}, options = {})
        super
        @file_manager = FileManager.new('tags', :relative)
        @diff_manager = TagDiffManager.new(@file_manager.load_data, after_schema_data)
      end

      def update_from_schema
        save_file_path = @file_manager.save_file_path
        case @type
        when :edited
          @diff_manager.process_by_using_diff_data do |after_edited_data|
            @file_manager.save(after_edited_data.to_yaml)
            logger.info "  Write schema file: \t#{save_file_path}"
          end
        when :existing
          result = @diff_manager.after_target_data
          logger.info "  Write schema file: \t#{save_file_path}"
        else
          raise NoImplementError
        end
      end
    end
  end
end
