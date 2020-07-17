# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'r2-oas/schema/v3/object/from_files/openapi_object'
require_relative 'base_builder'

module R2OAS
  module Schema
    module V3
      class DocBuilder < BaseBuilder
        attr_accessor :oas_doc, :pure_oas_doc

        def initialize(opts = {})
          super
        end

        def build_docs
          logger.info '[Build OAS schema files] start'
          logger.info '[Build OAS docs from schema files] start'
          build_docs_from_schema_files
          logger.info '[Build OAS docs from schema files] end'
          logger.info '[Build OAS schema files] end'
        end

        private

        def build_docs_from_schema_files
          result_before_squeeze = schema_files_paths.each_with_object({}) do |path, data|
            file_manager = FileManager.new(path)
            yaml = YAML.load_file(path)
            data.deep_merge!(yaml)
            logger.info " Use schema file: \t#{file_manager.save_file_path(type: :relative)}"
          end

          result = if many_paths_file_paths.present?
                     Squeezer.new(result_before_squeeze, many_paths_file_paths: many_paths_file_paths).squeeze_docs
                   else
                     result_before_squeeze
                  end
          
          @pure_oas_doc = result.dup
          rsult = FromFiles::OpenapiObject.new(result, opts).to_doc if use_plugin?
          @oas_doc = result
          
          File.write(output? ? output_path : doc_save_file_path, result.to_yaml)
        end
      end
    end
  end
end
