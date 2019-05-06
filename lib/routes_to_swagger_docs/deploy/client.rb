#frozen_string_literal:true

require_relative '../schema/base'
require 'fileutils'

# Scope Rails
module RoutesToSwaggerDocs
  module Deploy
    class Client < Schema::Base
      def deploy
        copy_swagger_ui_dist
        copy_swagger_ui_index
        copy_swagger_doc_file
      end

      private

      def copy_swagger_ui_dist
        docs_path = File.expand_path(Rails.root.join("docs"), __FILE__)
        return if FileTest.exists?(docs_path)        
        FileUtils.mkdir_p(docs_path) unless FileTest.exists?(docs_path)

        dist_path = File.expand_path("../swagger-ui/dist", __FILE__)
        FileUtils.cp_r(dist_path, docs_path)
      end

      def copy_swagger_ui_index
        index_path = File.expand_path("#{Rails.root.join("docs")}/index.html", __FILE__)
        raise "Exist docs already" if FileTest.exists?(index_path)
        
        @schema_file_path = doc_save_file_name
        template_path = File.expand_path("../swagger-ui/index.html.erb", __FILE__)
        template = File.read(template_path)
        index = ERB.new(template, nil, '%').result(binding)
        File.write(index_path, index)
      end

      def copy_swagger_doc_file
        swagger_file_path = File.expand_path(Rails.root.join("docs", doc_save_file_name), __FILE__)
        swagger_doc_file_path = File.expand_path("#{root_dir_path}/#{doc_save_file_name}")
        FileUtils.cp_r(swagger_doc_file_path, swagger_file_path)
      end
    end
  end
end
