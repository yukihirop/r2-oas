# frozen_string_literal: true

require_relative 'app_configuration/server'
require_relative 'app_configuration/swagger'
require_relative 'app_configuration/tool'
require_relative 'app_configuration/deprecation'

module R2OAS
  module AppConfiguration
    DEFAULT_VERSION = :v3
    DEFAULT_ROOT_DIR_PATH = './oas_docs'
    DEFAULT_SCHEMA_SAVE_DIR_NAME = 'src'
    DEFAULT_DOC_SAVE_FILE_NAME = 'oas_doc.yml'
    DEFAULT_FORCE_UPDATE_SCHEMA = false
    DEFAULT_USE_TAG_NAMESPACE = true
    DEFAULT_USE_SCHEMA_NAMESPACE = true
    DEFAULT_SERVER = Server.new
    DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA = 15
    DEFAULT_SWAGGER = Swagger.new
    # rubocop:disable Style/MutableConstant
    DEFAULT_HTTP_STATUSES_WHEN_HTTP_METHOD = {
      get: {
        default: %w[200 422],
        path_parameter: %w[200 404 422]
      },
      post: {
        default: %w[201 422],
        path_parameter: %w[201 404 422]
      },
      patch: {
        default: %w[204 422],
        path_parameter: %w[204 404 422]
      },
      put: {
        default: %w[204 422],
        path_parameter: %w[204 404 422]
      },
      delete: {
        default: %w[200 422],
        path_parameter: %w[200 404 422]
      }
    }
    DEFAULT_HTTP_METHODS_WHEN_GENERATE_REQUEST_BODY = %w[post patch put]
    DEFAULT_IGNORED_HTTP_STATUSES_WHEN_GENERATE_COMPONENT_SCHEMA = %w[204 404]
    # rubocop:enable Style/MutableConstant
    DEFAULT_TOOL = Tool.new
    # :dot or :underbar
    DEFAULT_NAMESPACE_TYPE = :dot
    DEFAULT_DEPLOY_DIR_PATH = './deploy_docs'
    EDFAULT_PLUGINS = [].freeze
    DEFAULT_LOCAL_PLUGINS_DIR_NAME = 'plugins'
    DEFAULT_LOCAL_TASKS_DIR_NAME = 'tasks'
    DEFAULT_OUTPUT_PATH = './oas_docs/dist/oas_doc.yml'
    DEFAULT_DEPRECATION = Deprecation.new

    PUBLIC_VALID_OPTIONS_KEYS = %i[
      version
      root_dir_path
      schema_save_dir_name
      doc_save_file_name
      force_update_schema
      use_tag_namespace
      use_schema_namespace
      server
      interval_to_save_edited_tmp_schema
      swagger
      http_statuses_when_http_method
      http_methods_when_generate_request_body
      ignored_http_statuses_when_generate_component_schema
      tool
      namespace_type
      deploy_dir_path
      plugins
      local_plugins_dir_name
      local_tasks_dir_name
      output_path
      deprecation
    ].freeze

    UNPUBLIC_VALID_OPTIONS_KEYS = %i[
      paths_config
      logger
    ].freeze

    VALID_OPTIONS_KEYS = PUBLIC_VALID_OPTIONS_KEYS + UNPUBLIC_VALID_OPTIONS_KEYS

    attr_accessor *PUBLIC_VALID_OPTIONS_KEYS

    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    private

    module_function def set_default(target)
      target.version                                              = DEFAULT_VERSION
      target.root_dir_path                                        = DEFAULT_ROOT_DIR_PATH
      target.schema_save_dir_name                                 = DEFAULT_SCHEMA_SAVE_DIR_NAME
      target.doc_save_file_name                                   = DEFAULT_DOC_SAVE_FILE_NAME
      target.force_update_schema                                  = DEFAULT_FORCE_UPDATE_SCHEMA
      target.use_tag_namespace                                    = DEFAULT_USE_TAG_NAMESPACE
      target.use_schema_namespace                                 = DEFAULT_USE_SCHEMA_NAMESPACE
      target.server                                               = DEFAULT_SERVER
      target.interval_to_save_edited_tmp_schema                   = DEFAULT_INTERVAL_TO_SAVE_EDITED_TMP_SCHEMA
      target.swagger                                              = DEFAULT_SWAGGER
      target.http_statuses_when_http_method                       = DEFAULT_HTTP_STATUSES_WHEN_HTTP_METHOD
      target.tool                                                 = DEFAULT_TOOL
      target.http_methods_when_generate_request_body              = DEFAULT_HTTP_METHODS_WHEN_GENERATE_REQUEST_BODY
      target.ignored_http_statuses_when_generate_component_schema = DEFAULT_IGNORED_HTTP_STATUSES_WHEN_GENERATE_COMPONENT_SCHEMA
      target.namespace_type                                       = DEFAULT_NAMESPACE_TYPE
      target.deploy_dir_path                                      = DEFAULT_DEPLOY_DIR_PATH
      target.plugins                                              = EDFAULT_PLUGINS
      target.local_plugins_dir_name                               = DEFAULT_LOCAL_PLUGINS_DIR_NAME
      target.local_tasks_dir_name                                 = DEFAULT_LOCAL_TASKS_DIR_NAME
      target.output_path                                          = DEFAULT_OUTPUT_PATH
      target.deprecation                                          = DEFAULT_DEPRECATION
    end
  end
end
