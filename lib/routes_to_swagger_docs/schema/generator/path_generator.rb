require 'forwardable'
require 'fileutils'
require_relative 'base_generator'

module RoutesToSwaggerDocs
  module Schema
    class PathGenerator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        sorted_schema_data = deep_sort(schema_data, "paths")
        @paths = sorted_schema_data["paths"]
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
        process_when_generate_paths(paths_override: true)
      end
      
      def generate_paths_from_routes_data
        process_when_generate_paths(paths_override: false)
      end
      
      def process_when_generate_paths(paths_override: false)
        logger.info " <Update schema files (paths)>"
        save_each_tags(@paths) do |tag_name, result|
          dirs = "paths"
          filename_with_namespace = tag_name
          save_path = save_path_for(filename_with_namespace, dirs)

          if use_deep_merge?(save_path)
            write_after_deep_merge(save_path, result)
          else
            File.write(save_path, result.to_yaml)
          end
          
          if paths_override
            logger.info "  Merge schema file: \t#{save_path}"
          else
            logger.info "  Write schema file: \t#{save_path}"
          end
        end
      end

      def use_deep_merge?(path)
        path.in? paths_config.many_paths_file_paths
      end
      
      def create_glob_paths_paths
        if many_paths_file_paths.present? && !skip_load_dot_paths
          many_paths_file_paths
        else
          ["#{schema_save_dir_path}/paths/**/**.yml"]
        end
      end

      def unit_paths_data_group_by_tags(unit_paths_data)
        unit_paths_data.each_with_object({}) do |(path, data_when_path), result|
          data_when_path.each do |verb, data_when_verb|
            tag_name = data_when_verb["tags"].first
            result[tag_name] ||= {}
            result[tag_name].deep_merge!({ 
              "paths" => { 
                path => {
                  verb => data_when_verb
                }
              }
            })
          end
        end
      end

      def save_each_tags(unit_paths_data, &block)
        unit_paths_data_group_by_tags(unit_paths_data).each do |tag_name, result|
          yield *[tag_name, result] if block_given?
        end
      end
    end
  end
end
