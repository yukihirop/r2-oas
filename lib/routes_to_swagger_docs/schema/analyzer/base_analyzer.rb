require_relative '../../errors'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class BaseAnalyzer
      def initialize(options = {})
        merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        (Configuration::VALID_OPTIONS_KEYS + options.keys).each do |key|
          send("#{key}=", merged_options[key])
        end
        
        @edited_schema = YAML.load_file(edited_schema_file_path) 
      end

      def update_schema
        raise NoImplementError
      end

      private

      attr_accessor *Configuration::VALID_OPTIONS_KEYS, :edited_schema_file_path

      def schema_save_dir_path
        File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
      end
    end
  end
end