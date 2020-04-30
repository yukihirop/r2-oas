# frozen_string_literal: true

require 'yaml'
require 'fileutils'
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
          local_store = Store.new(cache_docs)
          save_diff_schemas_from(local_store)
        end

        def save_diff_schemas_from(local_store)
          local_sha1s = local_store.data['data'].keys
          global_sha1s = store.data['data'].keys

          # Maake diff sha1s
          new_sha1s, modified_sha1s, added_sha1s = nil
          if exists_cache?
            modified_sha1s = global_sha1s - local_sha1s
            removed_sha1s = local_sha1s - global_sha1s
          else
            new_sha1s = global_sha1s - local_sha1s
          end

          # Make diff store
          new_store = store.dup_slice(*new_sha1s)
          modified_store = store.dup_slice(*modified_sha1s)
          removed_store = local_store.dup_slice(*removed_sha1s)

          is_exists_cache = exists_cache?
          if is_exists_cache || schema_file_do_not_exists?
            unless is_create_cache
              # Save schema files
              if new_store&.exists?
                new_store.save do |save_path|
                  logger.info "  Write schema file: \t#{save_path}"
                end
              end

              if removed_store&.exists?
                removed_store.delete do |delete_path|
                  logger.info "  Delete schema file: \t#{delete_path}"
                end
              end

              if modified_store&.exists?
                modified_store.save do |save_path|
                  logger.info "  Write schema file: \t#{save_path}"
                end
              end
            end
          else
            unless is_create_cache || is_exists_cache
              raise NoFileExistsError.new <<-ERR
              
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
