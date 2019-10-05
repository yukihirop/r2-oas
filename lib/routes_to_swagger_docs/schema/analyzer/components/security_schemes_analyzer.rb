require_relative '../base_analyzer'
require_relative '../../manager/file/components_file_manager'
require_relative '../../manager/diff/components_diff_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    module Components
      class SecuritySchemesAnalyzer < BaseAnalyzer
        def analyze_docs
          diff_manager = ComponentsDiffManager.new(@before_schema_data, @after_schema_data, { middle_category: 'securitySchemes'})
          diff_manager.process_by_using_diff_data do |schema_name, is_removed, is_added, is_leftovers, after_edited_data|
            file_manager = ComponentsFileManager.build("#/components/securitySchemes/#{schema_name}", :ref)
            save_file_path = file_manager.save_file_path

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
