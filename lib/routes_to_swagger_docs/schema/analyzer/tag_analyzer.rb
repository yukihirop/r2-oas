require_relative 'base_analyzer'
require_relative '../manager/file_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class TagAnalyzer < BaseAnalyzer
      def initialize(before_schema_data, after_schema_data = {}, options = {})
        super
        @file_manager = FileManager.new("tags", :relative)
      end

      def update_from_schema
        @file_manager.save(filtered_tags.to_yaml)
        logger.info "  Write schema file: \t#{@file_manager.save_file_path}"
      end

      private

      def filtered_tags
        case @type
        when :edited
          edited_tags_schema_data = @after_schema_data["tags"].each_with_object({}) do |data, result|
            result.deep_merge!({data["name"] => data })
          end
          tags_schema_from_local = @file_manager.load_data["tags"]

          result = tags_schema_from_local.map do |data|
            tag_name = data["name"]
            if tag_name.in? edited_tags_schema_data.keys
              edited_tags_schema_data[tag_name]
            else
              data
            end
          end

          { "tags" => result }
        when :existing
          { "tags" => @after_schema_data["tags"] }
        else
          raise 'Do not support type'
        end
      end
    end
  end
end