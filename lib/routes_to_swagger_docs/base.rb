module RoutesToSwaggerDocs
  class Base
    def initialize(schema_data = {}, options = {})
      merged_options = RoutesToSwaggerDocs.options.merge(options)
      
      (BaseConfiguration::VALID_OPTIONS_KEYS + options.keys).each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    private

    attr_accessor *BaseConfiguration::VALID_OPTIONS_KEYS

    def logger
      RoutesToSwaggerDocs.logger
    end

    def schema_save_dir_path
      File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
    end
      
    def doc_save_file_path
      File.expand_path("#{root_dir_path}/#{doc_save_file_name}")
    end
  end
end
