require_relative '../../routing/parser'
require_relative '../v3/openapi_object'

module RoutesToSwaggerDocs
  class BaseGenerator
    def initialize(options={})
      merged_options = RoutesToSwaggerDocs.options.merge(options)
      
      (Configuration::VALID_OPTIONS_KEYS + options.keys).each do |key|
        send("#{key}=", merged_options[key])
      end

      @all_routes = create_all_routes
      @docs = create_docs
      @glob_schema_paths = create_glob_schema_paths
    end

    private
    
    attr_accessor *Configuration::VALID_OPTIONS_KEYS, :unit_paths_file_path

    def logger
      ::Rails.logger
    end

    def create_all_routes
      ::Rails.application.reload_routes!
      ::Rails.application.routes.routes
    end

    # Scope Rails
    def create_docs
      routes_data = parser.routes_data
      tags_data = parser.tags_data
      
      docs = Schema::V3::OpenapiObject.new(routes_data, tags_data).to_doc
      
      if unit_paths_file_path.present?
        squeezer = Squeezer.new(docs, unit_paths_file_path)
        docs = squeezer.only_specify_paths
      end

      docs
    end

    def parser
      @parser ||= Routing::Parser.new(@all_routes)
    end

    def schema_file_do_not_exists?
      schema_files_paths.count == 0
    end

    def create_glob_schema_paths
      if unit_paths_file_path.present?
        exclude_paths_regexp_paths = "#{schema_save_dir_path}/**.yml"
        [unit_paths_file_path, exclude_paths_regexp_paths]
      else
        ["#{schema_save_dir_path}/**/**.yml"]
      end
    end

    def schema_files_paths
      Dir.glob(@glob_schema_paths)
    end

    def schema_save_dir_path
      File.expand_path("#{root_dir_path}/#{schema_save_dir_name}")
    end

    def doc_save_file_path
      File.expand_path("#{root_dir_path}/#{doc_save_file_name}")
    end


    class Squeezer
      def initialize(docs, unit_paths_file_path)
        @docs = docs
        @unit_paths_file_path = unit_paths_file_path
        @tag_name = create_tag_name
      end

      def only_specify_paths
        except_paths_schema = @docs.except("paths")
        slice_paths_schema = @docs["paths"].each_with_object({}) do |(path, data_when_path), result|
          data_when_path.values.each do |data_when_verb|
            include_tag_name = data_when_verb["tags"].include?(@tag_name)
            result.deep_merge!({ "#{path}" => data_when_path }) if include_tag_name
          end
        end

        except_paths_schema.deep_merge({ "paths" => slice_paths_schema })
      end

      def create_tag_name
        paths_from_local = YAML.load_file(@unit_paths_file_path)
        paths_from_local["paths"].values[0].values[0]["tags"][0]
      end
    end
  end
end
