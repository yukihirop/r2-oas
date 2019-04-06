require_relative '../../errors'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class BaseAnalyzer
      def initialize(edited_schema_file_path, options = {})
        self.merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        Configuration::VALID_OPTIONS_KEYS.each do |key|
          send("#{key}=", merged_options[key])
        end
        @edited_schema = YAML.load_file(edited_schema_file_path) 
      end

      def update_schema
        raise NoImplementError
      end

      private

      attr_accessor *Configuration::VALID_OPTIONS_KEYS, :merged_options

      def schema_save_dir_path
        File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
      end
    end
  end
end