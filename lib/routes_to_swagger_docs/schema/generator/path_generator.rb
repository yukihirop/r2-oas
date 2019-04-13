require 'forwardable'
require 'fileutils'
require_relative 'base_generator'

module RoutesToSwaggerDocs
  module Schema
    class PathGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @paths = schema_data["paths"] || scehma_data[:paths]
        @glob_schema_paths = create_glob_paths_paths
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
      
      alias :paths_files_paths :schema_files_paths
      alias :paths_file_do_not_exists? :schema_file_do_not_exists?
      
      def generate_paths_from_schema_fiels
        paths_from_schema_files = paths_files_paths.each_with_object({}) do |path, data|
          yaml = YAML.load_file(path)
          data.deep_merge!(yaml)
          full_path = File.expand_path(path, "./")
          logger.info "  Fetch schema file: \t#{full_path}"
        end
        @paths.deep_merge!(paths_from_schema_files["paths"])
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
          save_path = util.save_path
          File.write(save_path, result.to_yaml)
          
          if paths_override
            logger.info "  Merge schema file: \t#{save_path}"
          else
            logger.info "  Write schema file: \t#{save_path}"
          end
        end
      end
      
      def normalized_paths
        @paths.each_with_object({}) do |(path_name, data), result|
          tag_name = data.values.first["tags"].first
          merge_data = { "#{path_name}" => data }
          
          if result.has_key?(tag_name)
            result[tag_name].deep_merge!(merge_data)
          else
            result[tag_name] = merge_data
          end
        end
      end
      
      def paths_path
        "#{schema_save_dir_path}/paths"
      end
      
      def create_glob_paths_paths
        if unit_paths_file_path.present?
          [unit_paths_file_path]
        else
          ["#{schema_save_dir_path}/paths/**/**.yml"]
        end
      end
      
      class Utility
        extend Forwardable
        def_delegators :@path_generator, :paths_path
        
        def initialize(path_generator, tag_name)
          @path_generator = path_generator
          @tag_name = tag_name
        end

        def save_path
          FileUtils.mkdir_p(namespace_path) unless FileTest.exists?(namespace_path)

          if do_not_exist_namespace?
            File.expand_path("#{tag_name_path}.yml", "./")
          else
            File.expand_path("#{namespace_path}/#{tag_name_only}.yml", "./")
          end
        end

        private

        def tag_name_only
          @tag_name.split("/").last
        end
        
        def tag_name_path
          "#{paths_path}/#{@tag_name}"
        end
        
        def namespace_path
          "#{paths_path}/#{namespace}"
        end
        
        def do_not_exist_namespace?
          @tag_name.split("/").count == 1
        end
        
        def namespace
          tag_arr = @tag_name.split("/").reverse
          tag_arr.shift
          tag_arr.reverse.join("/")
        end
      end
    end
  end
end
