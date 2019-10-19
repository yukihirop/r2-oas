# frozen_string_literal: true

require 'r2-oas/schema/manager/file/path_item_file_manager'

module RoutesToSwaggerDocs
  module Configuration
    class PathsConfig
      def initialize(root_dir_path, schema_save_dir_name)
        @root_dir_path = root_dir_path
        @schema_save_dir_path = "#{root_dir_path}/#{schema_save_dir_name}"
      end

      def abs_paths_path
        File.expand_path("#{@root_dir_path}/.paths")
      end

      def all_load_paths?
        many_paths_file_paths.present?
      end

      def many_paths_file_paths
        @many_paths_file_paths ||= File.read(abs_paths_path).split("\n").each_with_object([]) do |relative_path, result|
          abs_path = File.expand_path("#{@schema_save_dir_path}/paths/#{relative_path}")
          result.push(abs_path) if FileTest.exists?(abs_path) && FileTest.file?(abs_path)
        end.uniq.compact.reject(&:empty?)
      end

      def create_dot_paths
        abs_root_path = File.expand_path(@root_dir_path)

        FileUtils.mkdir_p(abs_root_path) unless FileTest.exists?(abs_root_path)
        File.write(abs_paths_path, '') unless FileTest.exists?(abs_paths_path)
      end

      def many_components_file_paths
        @many_components_file_paths ||= many_paths_file_paths.each_with_object([]) do |unit_paths_path, result|
          file_manager = Schema::PathItemFileManager.new(unit_paths_path, :full)
          components_file_paths_at_path = file_manager.descendants_ref_paths
          result.push(*components_file_paths_at_path)
        end.uniq
      end
    end
  end
end
