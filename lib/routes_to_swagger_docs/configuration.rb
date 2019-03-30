#frozen_string_literal: true

module RoutesToSwaggerDocs
  module Configuration

    DEFAULT_ROOT_DIR_PATH = "./swagger_docs"
    DEFAULT_SCHEMA_SAVE_DIR_NAME = "schema"
    DEFAULT_DOC_SAVE_FILE_NAME = "swagger_doc.yml"
    DEFAULT_FORCE_UPDATE_SCHEMA = false

    VALID_OPTIONS_KEYS = [
      :root_dir_path,
      :schema_save_dir_name,
      :doc_save_file_name,
      :force_update_schema
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.send :set_default
    end

    def configure
       yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    private

    def set_default
      self.root_dir_path = DEFAULT_ROOT_DIR_PATH
      self.schema_save_dir_name = DEFAULT_SCHEMA_SAVE_DIR_NAME
      self.doc_save_file_name = DEFAULT_DOC_SAVE_FILE_NAME
      self.force_update_schema = DEFAULT_FORCE_UPDATE_SCHEMA
    end
  end
end