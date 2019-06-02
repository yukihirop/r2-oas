module RoutesToSwaggerDocs
  module BaseConfiguration
    class PathsConfig
      def initialize(root_dir_path, schema_save_dir_name)
        @root_dir_path = root_dir_path
        @schema_save_dir_path = "#{root_dir_path}/#{schema_save_dir_name}"
      end

      def abs_paths_path
        File.expand_path("#{@root_dir_path}/.paths")
      end

      def manay_paths_file_paths
        File.read(abs_paths_path).split("\n").each_with_object([]) do |relative_path, result|
          abs_path = File.expand_path("#{@schema_save_dir_path}/paths/#{relative_path}")
          result.push(abs_path) if FileTest.exists?(abs_path) && FileTest.file?(abs_path)
        end.uniq.compact.reject(&:empty?)
      end

      def create_dot_paths
        abs_root_path = File.expand_path(@root_dir_path)

        FileUtils.mkdir_p(abs_root_path) unless FileTest.exists?(abs_root_path)
        File.write(abs_paths_path, "") unless FileTest.exists?(abs_paths_path)
      end
    end
  end
end
