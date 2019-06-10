module RoutesToSwaggerDocs
  module Configuration
    class PathsConfig
      def initialize(root_dir_path)
        @root_dir_path = root_dir_path
      end

      def abs_paths_path
        File.expand_path("#{@root_dir_path}/.paths")
      end

      def manay_paths_file_paths
        File.read(abs_paths_path).split("\n").each_with_object([]) do |relative_path, result|
          abs_path = File.expand_path("#{@root_dir_path}/#{relative_path}")
          result.push(abs_path) if FileTest.exists?(abs_path)
        end
      end

      def create_dot_paths
        abs_root_path = File.expand_path(@root_dir_path)

        FileUtils.mkdir_p(abs_root_path) unless FileTest.exists?(abs_root_path)
        File.write(abs_dot_paths_path, "") unless FileTest.exists?(abs_paths_path)
      end
    end
  end
end
