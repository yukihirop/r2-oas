# frozen_string_literal: true

require 'routes_to_swagger_docs/schema/v3/base'
require 'routes_to_swagger_docs/schema/v3/manager/file_manager'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class BaseCleaner < Base
        def clean_docs
          clean_target_files.each do |file_path|
            file_manager = FileManager.new(file_path, :full)
            file_manager.delete
            yield file_manager.save_file_path if block_given?
          end
        end

        private

        def many_paths_file_paths
          Dir.glob("#{schema_save_dir_path}/paths/**/**.yml")
        end

        def clean_target_files
          raise 'Please implement in inherited class.'
        end
      end
    end
  end
end
