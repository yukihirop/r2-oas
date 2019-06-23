require_relative 'base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class TagAnalyzer < BaseAnalyzer
      def update_from_schema
        save_path = save_path_for("tags")
        result = create_save_schema
        File.write(save_path, result.to_yaml)
        logger.info "  Write schema file: \t#{save_path}"
      end

      private

      def create_save_schema
        case @type
        when :edited
          save_path = save_path_for("tags")
          edited_tags_schema = @after_schema_data["tags"].first
          tags_schema_from_local = YAML.load_file(save_path)["tags"]

          result = tags_schema_from_local.each_with_object([]) do |tag,result|
            if tag["name"].eql? edited_tags_schema["name"]
              tag = edited_tags_schema
            end
            result.push(tag)
          end.tap { |tag_schema| break { "tags" => tag_schema } }
        when :existing
          { "tags" => @after_schema_data["tags"] }
        else
          raise 'Do not support type'
        end
      end
    end
  end
end