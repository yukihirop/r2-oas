require_relative '../routing/parser'
require_relative '../schema/v3/openapi_object'

module RoutesToSwaggerDocs
  class BaseGenerator
    def initialize(options={})
      self.merged_options = RoutesToSwaggerDocs.options.merge(options)
      
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end

      set_all_routes
    end

    private

    attr_accessor :all_routes, :docs
    attr_accessor *Configuration::VALID_OPTIONS_KEYS, :merged_options

    def logger
      ::Rails.logger
    end

    def set_all_routes
      ::Rails.application.reload_routes!
      @all_routes = ::Rails.application.routes.routes
    end

    # Scope Rails
    def docs
      routes_data = parser.routes_data
      tags_data = parser.tags_data
      @docs ||= Schema::V3::OpenapiObject.new(routes_data, tags_data).to_doc
    end

    def parser
      @parser ||= Routing::Parser.new(all_routes)
    end

    def schema_file_do_not_exists?
      Dir.glob(schema_paths).count == 0
    end

    def schema_paths
      File.expand_path("#{schema_save_dir_path}/**/**.yml")
    end
  end
end
