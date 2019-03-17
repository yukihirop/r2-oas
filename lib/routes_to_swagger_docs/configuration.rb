module RoutesToSwaggerDocs
  module Configuration

    DEFAULT_ROOT_DIR_PATH = "./swagger_docs"
    DEFAULT_SCHEMA_SAVE_DIR_PATH = "#{DEFAULT_ROOT_DIR_PATH}/schema"
    DEFAULT_DOC_SAVE_FILE_PATH = "#{DEFAULT_ROOT_DIR_PATH}/swagger_doc.yml"
    DEFAULT_FORCE_UPDATE_SCHEMA = false

    VALID_OPTIONS_KEYS = [
      :root_dir_path,
      :schema_save_dir_path,
      :doc_save_file_path,
      :force_update_schema
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.send :set_default
    end

    def configure
       yield self
       send :update_property
    end

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    private

    def update_property
      self.schema_save_dir_path = "#{self.root_dir_path}/schema"
      self.doc_save_file_path = "#{self.root_dir_path}/swagger_doc.yml"
    end

    def set_default
      self.root_dir_path = DEFAULT_ROOT_DIR_PATH
      self.schema_save_dir_path = DEFAULT_SCHEMA_SAVE_DIR_PATH
      self.doc_save_file_path = DEFAULT_DOC_SAVE_FILE_PATH
      self.force_update_schema = DEFAULT_FORCE_UPDATE_SCHEMA
    end
  end
end