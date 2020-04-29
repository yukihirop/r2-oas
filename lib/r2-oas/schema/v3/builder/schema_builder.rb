# frozen_string_literal: true

require 'fileutils'
require_relative 'base_builder'
require_relative 'path_builder'
require_relative 'components_builder'
require 'r2-oas/schema/v3/manager/file_manager'

module R2OAS
  module Schema
    module V3
      class SchemaBuilder < BaseBuilder
        def initialize(options = {})
          super(options)
          @docs = create_docs
          @options = options
        end

        def build_docs
          if force_update_schema || schema_file_do_not_exists?
            logger.info '<From routes data>'
            build_docs_from_routes_data
          else
            logger.info '<From schema files>'
            build_docs_from_schema_fiels
          end
        end

        def create_docs
          if !skip_generate_docs
            super
          elsif skip_generate_docs && FileTest.exists?(doc_save_file_path)
            YAML.load_file(doc_save_file_path)
          else
            {}
          end
        end

        private

        def build_docs_from_schema_fiels
          process_when_build_docs do |save_file_path|
            logger.info " Merge schema file: \t#{save_file_path}"
          end
        end

        def build_docs_from_routes_data
          process_when_build_docs do |save_file_path|
            logger.info " Write schema file: \t#{save_file_path}"
          end
        end

        def process_when_build_docs
          logger.info '<Update schema files>'
          @docs.each do |field_name, data|
            result = { field_name.to_s => data }

            case field_name
            when 'paths'
              logger.info ' [Build OAS schema files (paths)] start'
              PathBuilder.new(result, @options).build_docs
              logger.info ' [Build OAS schema files (paths)] end'
            when 'components'
              logger.info ' [Build OAS schema files (components)] start'
              ComponentsBuilder.new(result, @options).build_docs
              logger.info ' [Build OAS schema files (components)] end'
            else
              file_manager = FileManager.new(field_name, :relative)
              file_manager.save(result.to_yaml)

              yield file_manager.save_file_path(type: :relative) if block_given?
            end
          end
        end
      end
    end
  end
end
