# frozen_string_literal: true

require 'forwardable'
require 'fileutils'
require_relative '../base_generator'
require 'r2-oas/schema/v3/manager/file/components_file_manager'

module R2OAS
  module Schema
    module V3
      module Components
        class ObjectGenerator < BaseGenerator
          def initialize(schema_data = {}, options = {})
            super(options.except(:middle_category))
            @major_category = 'components'
            @middle_category = options[:middle_category]
            sorted_schema_data = deep_sort(schema_data, @middle_category)
            @components_objects = sorted_schema_data[@middle_category]
            @glob_schema_paths = create_glob_components_objects_paths
          end

          def generate_docs
            if components_objects_file_do_not_exists?
              logger.info ' <From routes data>'
              generate_docs_from_routes_data
            else
              logger.info ' <From schema files>'
              generate_docs_from_schema_fiels
            end
          end

          private

          alias components_objects_files_paths schema_files_paths
          alias components_objects_file_do_not_exists? schema_file_do_not_exists?

          def generate_docs_from_schema_fiels
            components_schemas_from_schema_files = components_objects_files_paths.each_with_object({}) do |path, data|
              yaml = YAML.load_file(path)
              data.deep_merge!(yaml)
              full_path = File.expand_path(path, './')
              logger.info "  Fetch Components schema file: \t#{full_path}"
            end
            @components_objects.deep_merge!(components_schemas_from_schema_files[@major_category][@middle_category])

            process_when_generate_docs do |save_file_path|
              logger.info "  Merge schema file: \t#{save_file_path}"
            end
          end

          def generate_docs_from_routes_data
            process_when_generate_docs do |save_file_path|
              logger.info "  Write schema file: \t#{save_file_path}"
            end
          end

          def process_when_generate_docs
            logger.info " <Update Components schema files (#{@major_category}/#{@middle_category})>"
            @components_objects&.each do |schema_name, data|
              result = {
                @major_category => {
                  @middle_category => { schema_name.to_s => data }
                }
              }

              relative_path = "#{@major_category}/#{@middle_category}/#{schema_name}"
              file_manager = ComponentsFileManager.build(relative_path, :relative)
              file_manager.save(result.to_yaml) unless file_manager.skip_save?

              yield file_manager.save_file_path(type: :relative) if block_given?
            end
          end

          def create_glob_components_objects_paths
            many_components_file_paths.select do |file_path|
              file_path.include? "#{schema_save_dir_path}/#{@major_category}/#{@middle_category}"
            end
          end
        end
      end
    end
  end
end
