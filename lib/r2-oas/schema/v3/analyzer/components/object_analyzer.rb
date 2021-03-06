# frozen_string_literal: true

require_relative '../base_analyzer'
require 'r2-oas/schema/v3/manager/file/components_file_manager'
require 'r2-oas/schema/v3/manager/diff/components_diff_manager'

# Scope Rails
module R2OAS
  module Schema
    module V3
      module Components
        class ObjectAnalyzer < BaseAnalyzer
          def initialize(before_schema_data, after_schema_data, options = {})
            super(before_schema_data, after_schema_data, options.except(:middle_category))
            @major_category = 'components'
            @middle_category = options[:middle_category]
          end

          def analyze_docs
            diff_manager = ComponentsDiffManager.new(@before_schema_data, @after_schema_data, middle_category: @middle_category)
            diff_manager.process_by_using_diff_data do |schema_name, is_removed, is_added, is_leftovers, after_edited_data|
              file_manager = ComponentsFileManager.build("#/#{@major_category}/#{@middle_category}/#{schema_name}", :ref)
              save_file_path = file_manager.save_file_path(type: :relative)

              if is_removed && !is_added && !is_leftovers
                file_manager.delete
                logger.info "  Delete schema file: \t#{save_file_path}"
              else
                file_manager.save(after_edited_data.to_yaml)
                logger.info "  Write schema file: \t#{save_file_path}"
              end
            end
          end
        end
      end
    end
  end
end
