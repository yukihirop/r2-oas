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
        process_when_generate_paths
      end
      
      def process_when_generate_paths(paths_override: false)
        logger.info " <Update schema files (paths)>"
        normalized_paths.each do |tag_name, data|
          result = { "paths" => data }

          dirs = "paths"
          filename_with_namespace = tag_name
          save_path = save_path_for(filename_with_namespace, dirs)
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
      
      def create_glob_paths_paths
        if unit_paths_file_path.present?
          [unit_paths_file_path]
        else
          ["#{schema_save_dir_path}/paths/**/**.yml"]
        end
      end
    end
  end
end
