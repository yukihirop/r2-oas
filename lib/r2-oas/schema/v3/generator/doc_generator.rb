# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'r2-oas/errors'
require 'r2-oas/lib/three-way-merge/twm'
require 'r2-oas/schema/v3/manager/file_manager'
require_relative 'base_generator'
require_relative 'schema_generator'

module R2OAS
  module Schema
    module V3
      class DocGenerator < BaseGenerator
        def initialize(options = {})
          super
          @schema_generator = SchemaGenerator.new(options)
        end

        def generate_docs
          logger.info '[Generate OAS schema files] start'
          @schema_generator.generate_docs
          save_schemas_from_store
          logger.info '[Generate OAS schema files] end'
        end

        private

        def save_schemas_from_store
          local_store = ::R2OAS::Store.new(cache_docs)

          # Check checksum
          unless local_store.checksum?
            raise R2OAS::ChecksumError, <<-ERR

              Invalid file: #{relative_cahe_docs_path}
              Please delete #{relative_cahe_docs_path} and execute the following command again.

              CACHE_DOCS=true bundle exec rake routes:oas:docs
            ERR
          end

          save_diff_schemas_from(local_store)
        end

        def save_diff_schemas_from(local_store)
          local_sha1s = local_store.data['data'].keys
          global_sha1s = store.data['data'].keys

          # Maake diff sha1s
          new_sha1s, after_sha1s, before_sha1s = nil
          if exists_cache?
            after_sha1s = global_sha1s - local_sha1s
            before_sha1s = local_sha1s - global_sha1s
          else
            new_sha1s = global_sha1s - local_sha1s
          end

          # Make diff store
          new_store = store.dup_slice(*new_sha1s)
          after_store = store.dup_slice(*after_sha1s)
          before_store = local_store.dup_slice(*before_sha1s)

          is_exists_cache = exists_cache?
          if is_exists_cache || schema_file_do_not_exists?
            unless is_create_cache
              # First try
              if new_store&.exists?
                new_store.save do |save_path|
                  logger.info "  Write schema file: \t#{save_path}"
                end
              end

              # Change routing
              after_store.diff_from(before_store) do |analyze_data|
                analyze_data.each do |file_path, data|
                  left = data['after']
                  orig = data['before']
                  right = FileManager.new(file_path, :full).load_data
                  merged3 =  Twm.yaml_merge(left, orig, right)
                  analyzer = Analyzer.new({}, merged3, type: :edited)
                  analyzer.analyze_docs
                end
              end

              # TODO: Fix Bugs
              # Delete paths/unknown.yml
              file_manager = FileManager.new(unknown_paths_path, :full)
              file_manager.delete
            end
          else
            unless is_create_cache || is_exists_cache
              raise NoFileExistsError, <<-ERR

                Can't find the file #{relative_cahe_docs_path}
                Please execute the following command to create #{relative_cahe_docs_path}

                CACHE_DOCS=true bundle exec rake routes:oas:docs
              ERR
            end
          end

          # Save docs cache
          deflated_cache_docs = Zlib::Deflate.deflate(Marshal.dump(store.data))
          IO.binwrite(abs_cache_docs_path, deflated_cache_docs)
          if is_exists_cache
            logger.info "[Generate OAS docs] Update cache at #{relative_cahe_docs_path}"
          else
            logger.info "[Generate OAS docs] Create cache at #{relative_cahe_docs_path}"
          end
        end
      end
    end
  end
end
