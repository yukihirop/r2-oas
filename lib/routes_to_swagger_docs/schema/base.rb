# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Base
      def initialize(schema_data = {}, options = {})
        merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        (Configuration::VALID_OPTIONS_KEYS + options.keys).each do |key|
          send("#{key}=", merged_options[key])
        end
      end

      private

      attr_accessor *Configuration::VALID_OPTIONS_KEYS

      def schema_save_dir_path
        File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
      end
      
      def doc_save_file_path
        File.expand_path("#{root_dir_path}/#{doc_save_file_name}")
      end

      def save_path_for(dirs, filename_with_namespace)
        data_for_namespace = filename_with_namespace.split("/").reverse
        data_for_namespace.shift
        namespace = data_for_namespace.reverse.join("/")
        namespace_path = File.expand_path("#{schema_save_dir_path}/#{dirs}/#{namespace}")
        FileUtils.mkdir_p(namespace_path) unless FileTest.exists?(namespace_path)

        File.expand_path("#{schema_save_dir_path}/#{dirs}/#{filename_with_namespace}.yml")
      end
    end
  end
end