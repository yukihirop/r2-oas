# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require_relative 'base_builder'
require_relative 'schema_builder'

module R2OAS
  module Schema
    module V3
      class DocBuilder < BaseBuilder
        attr_accessor :oas_doc

        def initialize(options = {})
          super
          @schema_builder = SchemaBuilder.new(options)
        end

        def build_docs
          logger.info '[Build OAS schema files] start'
          logger.info '[Build OAS docs from schema files] start'
          build_docs_from_schema_files
          logger.info '[Build OAS docs from schema files] end'
          logger.info '[build OAS schema files] end'
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

          @oas_doc = result
          File.write(doc_save_file_path, result.to_yaml)
        end
      end
    end
  end
end
