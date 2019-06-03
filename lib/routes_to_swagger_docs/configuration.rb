#frozen_string_literal: true

require_relative 'configuration/server'
require_relative 'configuration/swagger'

module RoutesToSwaggerDocs
  module Configuration

    DEFAULT_ROOT_DIR_PATH = "./swagger_docs"
    DEFAULT_SCHEMA_SAVE_DIR_NAME = "schema"
    DEFAULT_DOC_SAVE_FILE_NAME = "swagger_doc.yml"
    DEFAULT_FORCE_UPDATE_SCHEMA = false
    DEFAULT_USE_TAG_NAMESPACE = true
    DEFAULT_USE_SCHEMA_NAMESPACE = true
    DEFAULT_SERVER = Server.new
    DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA = 15
    DEFAULT_SWAGGER = Swagger.new

    VALID_OPTIONS_KEYS = [
      :root_dir_path,
      :schema_save_dir_name,
      :doc_save_file_name,
      :force_update_schema,
      :use_tag_namespace,
      :use_schema_namespace,
      :server,
      :interval_to_save_edited_tmp_schema,
      :swagger
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
      self.root_dir_path                      = DEFAULT_ROOT_DIR_PATH
      self.schema_save_dir_name               = DEFAULT_SCHEMA_SAVE_DIR_NAME
      self.doc_save_file_name                 = DEFAULT_DOC_SAVE_FILE_NAME
      self.force_update_schema                = DEFAULT_FORCE_UPDATE_SCHEMA
      self.use_tag_namespace                  = DEFAULT_USE_TAG_NAMESPACE
      self.use_schema_namespace               = DEFAULT_USE_SCHEMA_NAMESPACE
      self.server                             = DEFAULT_SERVER
      self.interval_to_save_edited_tmp_schema = DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA
      self.swagger                            = DEFAULT_SWAGGER
    end
  end
end