# frozen_string_literal:true

require 'fileutils'

# Scope Rails
module R2OAS
  module Deploy
    class Client < Schema::Base
      SWAGGER_UI_ZIP_URL = 'https://github.com/swagger-api/swagger-ui/releases/latest/download/swagger-ui.zip'

      def initialize(options = {})
        super
        @download_dir = SecureRandom.uuid[0..7]
        @base_dir = File.expand_path(Rails.root.join(@download_dir), __FILE__)
        @zip_path = File.expand_path(Rails.root.join(@download_dir, 'swagger-ui.zip'), __FILE__)
        @dist_path = nil
      end

      def download_swagger_ui_dist
        FileUtils.mkdir_p(@base_dir)
        return false unless system("curl -fsSL -o #{@zip_path} #{SWAGGER_UI_ZIP_URL}")
        return false unless system("unzip -o -q #{@zip_path} -d #{@base_dir}")

        # Find the actual dist directory after extraction
        # swagger-ui.zip extracts to swagger-ui-<version>/dist/
        extracted_dirs = Dir.glob(File.join(@base_dir, 'swagger-ui-*'))
        if extracted_dirs.empty?
          # Fallback: check if dist exists directly
          dist_path = File.join(@base_dir, 'dist')
          @dist_path = File.expand_path(dist_path) if Dir.exist?(dist_path)
        else
          dist_path = File.join(extracted_dirs.first, 'dist')
          @dist_path = File.expand_path(dist_path) if Dir.exist?(dist_path)
        end

        unless @dist_path && Dir.exist?(@dist_path)
          raise "Failed to find dist directory in extracted swagger-ui archive"
        end

        true
      end

      def deploy
        copy_swagger_ui_dist
        copy_swagger_ui_index
        copy_oas_doc_file
      ensure
        remove_download_dist
      end

      private

      def copy_swagger_ui_dist
        raise "dist directory not found. Please call download_swagger_ui_dist first." unless @dist_path

        docs_path = File.expand_path(Rails.root.join(deploy_dir_path), __FILE__)
        dist_dest_path = File.join(docs_path, 'dist')
        FileUtils.mkdir_p(File.dirname(dist_dest_path))
        FileUtils.rm_rf(dist_dest_path) if Dir.exist?(dist_dest_path)
        FileUtils.cp_r(@dist_path, dist_dest_path)
      end

      def copy_swagger_ui_index
        index_path = File.expand_path(Rails.root.join(deploy_dir_path, 'index.html'), __FILE__)
        @schema_file_path = doc_save_file_name
        template_path = File.expand_path('swagger-ui/index.html.erb', __dir__)
        template = File.read(template_path)
        index = make_index(template)
        File.write(index_path, index)
      end

      def copy_oas_doc_file
        swagger_file_path = File.expand_path(Rails.root.join(deploy_dir_path, doc_save_file_name), __FILE__)
        oas_doc_file_path = File.expand_path(output_path)
        FileUtils.cp_r(oas_doc_file_path, swagger_file_path)
      end

      def remove_download_dist
        FileUtils.rm_rf(@base_dir) if @base_dir && Dir.exist?(@base_dir)
      end

      # [ref]
      # https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Lint/ErbNewArguments
      def make_index(template)
        if RUBY_VERSION >= '2.6'
          ERB.new(template, trim_mode: '%').result(binding)
        else
          # rubocop:disable Lint/ErbNewArguments
          ERB.new(template, nil, trim_mode: '%').result(binding)
          # rubocop:enable Lint/ErbNewArguments
        end
      end
    end
  end
end
