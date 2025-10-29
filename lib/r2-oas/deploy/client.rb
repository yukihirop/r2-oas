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
        @dist_path = File.expand_path(Rails.root.join(@download_dir, 'dist'), __FILE__)
        @zip_path = File.expand_path(Rails.root.join(@download_dir, 'swagger-ui.zip'), __FILE__)
      end

      def download_swagger_ui_dist
        base_dir = File.expand_path(Rails.root.join(@download_dir), __FILE__)
        FileUtils.mkdir_p(base_dir)
        system("curl -fsSL -o #{@zip_path} #{SWAGGER_UI_ZIP_URL}") &&
          system("unzip -o -q #{@zip_path} -d #{base_dir}")
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
        docs_path = File.expand_path(Rails.root.join(deploy_dir_path), __FILE__)
        FileUtils.mkdir_p(docs_path)
        FileUtils.cp_r(@dist_path, docs_path)
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
        FileUtils.rm_rf(File.expand_path(Rails.root.join(@download_dir), __FILE__))
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
