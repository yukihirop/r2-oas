require_relative 'base_analyzer'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class TagAnalyzer < BaseAnalyzer
      def update_from_edited_schema
        tags_schma_path = "#{schema_save_dir_path}/tags.yml"
        
        edited_tags_schema = @edited_schema["tags"].first
        tags_schema_from_local = YAML.load_file(tags_schma_path)["tags"]

        result = tags_schema_from_local.each_with_object([]) do |tag,result|
          if tag["name"].eql? edited_tags_schema["name"]
            tag = edited_tags_schema
          end
          result.push(tag)
        end.tap { |tag_schema| break { "tags" => tag_schema } }
        
        File.write(tags_schma_path, result.to_yaml)
      end
    end
  end
end