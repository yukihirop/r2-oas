# frozen_string_literal: true

module ConfigHelper
  def reset_config
    R2OAS.configure do |config|
      config.version                            = :v3
      config.root_dir_path                      = Rails.root.join('swagger_docs').to_s
      config.schema_save_dir_name               = 'src'
      config.doc_save_file_name                 = 'swagger_doc.yml'
      config.force_update_schema                = false
      config.use_tag_namespace                  = true
      config.use_schema_namespace               = false
      config.interval_to_save_edited_tmp_schema = 15

      config.server.data = [
        {
          url: 'http://localhost:3000',
          description: 'localhost'
        }
      ]

      config.swagger.configure do |swagger|
        swagger.ui.image            = 'swaggerapi/swagger-ui'
        swagger.ui.port             = '8080'
        swagger.ui.exposed_port     = '8080/tcp'
        swagger.ui.volume           = '/app/swagger.json'
        swagger.editor.image        = 'swaggerapi/swagger-editor'
        swagger.editor.port         = '81'
        swagger.editor.exposed_port = '8080/tcp'
      end

      config.use_object_classes = {
        info_object: R2OAS::Schema::V3::InfoObject,
        paths_object: R2OAS::Schema::V3::PathsObject,
        path_item_object: R2OAS::Schema::V3::PathItemObject,
        external_document_object: R2OAS::Schema::V3::ExternalDocumentObject,
        components_object: R2OAS::Schema::V3::ComponentsObject,
        components_schema_object: R2OAS::Schema::V3::Components::SchemaObject,
        components_request_body_object: R2OAS::Schema::V3::Components::RequestBodyObject
      }

      config.http_statuses_when_http_method = {
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

      config.http_methods_when_generate_request_body = %w[post patch put]

      config.tool.paths_stats.configure do |paths_stats|
        paths_stats.month_to_turn_to_warning_color = 3
        paths_stats.warning_color                  = :red
        paths_stats.table_title_color              = :yellow
        paths_stats.heading_color                  = :yellow
        paths_stats.highlight_color                = :magenta
      end

      # :dot or :underbar
      config.namespace_type = :underbar
    end
  end
end
