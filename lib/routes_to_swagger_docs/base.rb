# frozen_string_literal: true

module RoutesToSwaggerDocs
  class Base
    def initialize(options = {})
      merged_options = RoutesToSwaggerDocs.options.merge(options)

      (AppConfiguration::VALID_OPTIONS_KEYS + options.keys).each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    private

    attr_accessor *AppConfiguration::VALID_OPTIONS_KEYS

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
