# frozen_string_literal:true

require 'fileutils'

# Scope Rails
module R2OAS
  module Deploy
    class Client < Schema::Base
      # Get master branch tarball from GitHub API
      SWAGGER_UI_TARBALL_URL = 'https://api.github.com/repos/swagger-api/swagger-ui/tarball/master'

      def initialize(options = {})
        super
        @download_dir = SecureRandom.uuid[0..7]
        @base_dir = File.expand_path(Rails.root.join(@download_dir), __FILE__)
        @tar_path = File.expand_path(Rails.root.join(@download_dir, 'swagger-ui-master.tar.gz'), __FILE__)
        @dist_path = nil
        logger.info("[deploy] initialize: download_dir=#{@download_dir} base_dir=#{@base_dir} tar_path=#{@tar_path}")
      end

      def download_swagger_ui_dist
        logger.info("[deploy] download_swagger_ui_dist: base_dir=#{@base_dir}")
        FileUtils.mkdir_p(@base_dir)
        
        curl_ok = system("curl -fsSL -o #{@tar_path} #{SWAGGER_UI_TARBALL_URL}")
        logger.info("[deploy] curl result: ok=#{curl_ok} url=#{SWAGGER_UI_TARBALL_URL} -> #{@tar_path}")
        return false unless curl_ok

        tar_ok = system("tar -xzf #{@tar_path} -C #{@base_dir}")
        logger.info("[deploy] tar extract result: ok=#{tar_ok} tar=#{@tar_path} dest=#{@base_dir}")
        return false unless tar_ok

        # Find the actual dist directory after extraction
        # GitHub tarball extracts to swagger-api-swagger-ui-<sha>/dist/
        extracted_dirs = Dir.glob(File.join(@base_dir, 'swagger-api-swagger-ui-*'))
        logger.info("[deploy] extracted_dirs: #{extracted_dirs}")
        
        if extracted_dirs.empty?
          # Fallback: check if dist exists directly
          dist_path = File.join(@base_dir, 'dist')
          logger.info("[deploy] check direct dist: #{dist_path} exists=#{Dir.exist?(dist_path)}")
          @dist_path = File.expand_path(dist_path) if Dir.exist?(dist_path)
        else
          dist_path = File.join(extracted_dirs.first, 'dist')
          logger.info("[deploy] check versioned dist: #{dist_path} exists=#{Dir.exist?(dist_path)}")
          @dist_path = File.expand_path(dist_path) if Dir.exist?(dist_path)
        end

        unless @dist_path && Dir.exist?(@dist_path)
          raise "Failed to find dist directory in extracted swagger-ui archive"
        end
        logger.info("[deploy] dist_path detected: #{@dist_path}")

        true
      end

      def deploy
        logger.info('[deploy] start deploy')
        copy_swagger_ui_dist
        copy_swagger_ui_index
        copy_oas_doc_file
      ensure
        logger.info('[deploy] cleanup download artifacts')
        remove_download_dist
      end

      private

      def copy_swagger_ui_dist
        raise "dist directory not found. Please call download_swagger_ui_dist first." unless @dist_path

        docs_path = File.expand_path(Rails.root.join(deploy_dir_path), __FILE__)
        dist_dest_path = File.join(docs_path, 'dist')
        logger.info("[deploy] copy dist: src=#{@dist_path} dest=#{dist_dest_path}")
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
        logger.info("[deploy] write index.html: path=#{index_path} schema_file=#{@schema_file_path}")
        File.write(index_path, index)
      end

      def copy_oas_doc_file
        swagger_file_path = File.expand_path(Rails.root.join(deploy_dir_path, doc_save_file_name), __FILE__)
        oas_doc_file_path = File.expand_path(output_path)
        logger.info("[deploy] copy oas doc: src=#{oas_doc_file_path} dest=#{swagger_file_path}")
        FileUtils.cp_r(oas_doc_file_path, swagger_file_path)
      end

      def remove_download_dist
        logger.info("[deploy] remove temp: base_dir=#{@base_dir}")
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
