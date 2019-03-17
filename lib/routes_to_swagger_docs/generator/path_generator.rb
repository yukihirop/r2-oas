require 'forwardable'
require 'fileutils'
require_relative 'base_generator'

module RoutesToSwaggerDocs
  class PathGenerator < BaseGenerator
    def initialize(options)
      super(options)
      @paths = options["paths"] || options[:paths]
    end

    def generate_paths
      if paths_file_do_not_exists?
        logger.info " <From routes data>"
        generate_paths_from_routes_data
      else
        logger.info " <From schema files>"
        generate_paths_from_schema_fiels        
      end
    end

    private

    attr_accessor :paths

    def generate_paths_from_schema_fiels
      paths_from_schema_files = Dir.glob(paths_paths).each_with_object({}) do |path, data|
        yaml = YAML.load_file(path)
        data.deep_merge!(yaml)
        full_path = File.expand_path(path, "./")
        logger.info "  Fetch schema file: \t#{full_path}"
      end
      paths.deep_merge!(paths_from_schema_files["paths"])
      process_when_generate_paths(paths_override: true)
    end

    def generate_paths_from_routes_data
      FileUtils.mkdir_p(paths_path) unless FileTest.exists?(paths_path)
      process_when_generate_paths
    end

    def process_when_generate_paths(paths_override: false)
      logger.info " <Update schema files (paths)>"
      normalized_paths.each do |tag_name, data|
        result = { "paths" => data }

        util = Utility.new(self, tag_name)
        tag_name_path = util.tag_name_path
        tag_name_only = util.tag_name_only
        namespace_path = util.namespace_path

        save_path = ""
        if util.do_not_exist_namespace?
          save_path = File.expand_path("#{tag_name_path}.yml", "./")
        else
          save_path = File.expand_path("#{namespace_path}/#{tag_name_only}.yml", "./")
          FileUtils.mkdir_p(namespace_path) unless FileTest.exists?(namespace_path)
        end
        File.write(save_path, result.to_yaml)

        if paths_override
          logger.info "  Merge schema file: \t#{save_path}"
        else
          logger.info "  Write schema file: \t#{save_path}"
        end
      end
    end

    def normalized_paths
      paths.each_with_object({}) do |(path_name, data), result|
        tag_name = tag_name(data)
        merge_data = { "#{path_name}" => data }

        if result.has_key?(tag_name)
          result[tag_name].deep_merge!(merge_data)
        else
          result[tag_name] = merge_data
        end
      end
    end

    def tag_name(data)
      data.values.first["tags"].first
    end

    def paths_file_do_not_exists?
      Dir.glob(paths_paths).count == 0
    end

    def paths_path
      "#{schema_save_dir_path}/paths"
    end

    def paths_paths
      "#{schema_save_dir_path}/paths/**/**.yml"
    end

    class Utility
      extend Forwardable
      def_delegators :@path_generator, :paths_path

      def initialize(path_generator, tag_name)
        @path_generator = path_generator
        @tag_name = tag_name
      end

      def tag_name_only
        tag_name.split("/").last
      end

      def tag_name_path
        "#{paths_path}/#{tag_name}"
      end

      def namespace_path
        "#{paths_path}/#{namespace}"
      end

      def do_not_exist_namespace?
        tag_name.split("/").count == 1
      end

      def namespace
        tag_arr = tag_name.split("/").reverse
        tag_arr.shift
        tag_arr.reverse.join("/")
      end

      private

      attr_accessor :tag_name
    end
  end
end
