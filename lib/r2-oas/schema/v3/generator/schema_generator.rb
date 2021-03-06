# frozen_string_literal: true

require 'fileutils'
require_relative 'base_generator'
require_relative 'path_generator'
require_relative 'components_generator'
require 'r2-oas/schema/v3/manager/file_manager'

module R2OAS
  module Schema
    module V3
      class SchemaGenerator < BaseGenerator
        def initialize(options = {})
          super(options)
          @docs = create_docs
          @options = options
        end

        def generate_docs
          logger.info '<From routes data>'
          generate_docs_from_routes_data
        end

        private

        def generate_docs_from_routes_data
          process_when_generate_docs do |save_file_path|
            logger.info " Add schema file into store: \t#{save_file_path}"
          end
        end

        def process_when_generate_docs
          logger.info '<Update schema files>'
          @docs.each do |field_name, data|
            result = { field_name.to_s => data }

            case field_name
            when 'paths'
              logger.info ' [Generate OAS schema files (paths)] start'
              PathGenerator.new(result, @options).generate_docs
              logger.info ' [Generate OAS schema files (paths)] end'
            when 'components'
              logger.info ' [Generate OAS schema files (components)] start'
              ComponentsGenerator.new(result, @options).generate_docs
              logger.info ' [Generate OAS schema files (components)] end'
            else
              file_manager = FileManager.new(field_name, :relative)
              save_file_path = file_manager.save_file_path(type: :relative)
              store.add(save_file_path, result.to_yaml)

              yield file_manager.save_file_path(type: :relative) if block_given?
            end
          end
        end
      end
    end
  end
end
