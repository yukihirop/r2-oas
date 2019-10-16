require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Configuration do
  describe 'configure' do
    before(:all) do
      class RtsdInfoObject < RoutesToSwaggerDocs::Schema::V3::InfoObject; end;
      class RtsdPathsObject < RoutesToSwaggerDocs::Schema::V3::PathsObject; end;
      class RtsdPathItemObject < RoutesToSwaggerDocs::Schema::V3::PathItemObject; end;
      class RtsdExternalDocumentObject < RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject; end;
      class RtsdComponentsObject < RoutesToSwaggerDocs::Schema::V3::ComponentsObject; end;
      module Components
        class RtsdSchemaObject < RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject; end;
        class RtsdRequestBodyObject < RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject; end;
      end
    end

    context 'when default setting' do
      before do
        class DefaultDummy
          extend RoutesToSwaggerDocs::Configuration
        end
      end

      subject { DefaultDummy.options }

      it 'should set correctly' do
        expect(subject[:version]).to eq :v3
        expect(subject[:root_dir_path]).to eq "./swagger_docs"
        expect(subject[:schema_save_dir_name]).to eq "src"
        expect(subject[:doc_save_file_name]).to eq "swagger_doc.yml"
        expect(subject[:force_update_schema]).to eq false
        expect(subject[:use_tag_namespace]).to eq true
        expect(subject[:use_schema_namespace]).to eq true
        expect(subject[:namespace_type]).to eq :underbar
        expect(subject[:http_statuses_when_http_method][:get][:default]).to include("200", "422")
        expect(subject[:http_statuses_when_http_method][:get][:path_parameter]).to include("200", "404", "422")
        expect(subject[:http_statuses_when_http_method][:post][:default]).to include("201", "422")
        expect(subject[:http_statuses_when_http_method][:post][:path_parameter]).to include("201", "404", "422")
        expect(subject[:http_statuses_when_http_method][:patch][:default]).to include("204", "422")
        expect(subject[:http_statuses_when_http_method][:patch][:path_parameter]).to include("204", "404", "422")
        expect(subject[:http_statuses_when_http_method][:put][:default]).to include("204", "422")
        expect(subject[:http_statuses_when_http_method][:put][:path_parameter]).to include("204", "404", "422")
        expect(subject[:http_statuses_when_http_method][:delete][:default]).to include("200", "422")
        expect(subject[:http_statuses_when_http_method][:delete][:path_parameter]).to include("200", "404", "422")
        # server configuration
        expect(subject[:server].data[0][:url]).to eq 'http://localhost:3000'
        expect(subject[:server].data[0][:description]).to eq 'localhost'
        # swagger configuration
        expect(subject[:swagger].ui.image).to eq 'swaggerapi/swagger-ui'
        expect(subject[:swagger].ui.port).to eq '8080'
        expect(subject[:swagger].ui.exposed_port).to eq '8080/tcp'
        expect(subject[:swagger].ui.volume).to eq '/app/swagger.json'
        expect(subject[:swagger].editor.image).to eq 'swaggerapi/swagger-editor'
        expect(subject[:swagger].editor.port).to eq '81'
        expect(subject[:swagger].editor.exposed_port).to eq '8080/tcp'
        # object classes
        expect(subject[:use_object_classes][:info_object]).to eq RoutesToSwaggerDocs::Schema::V3::InfoObject
        expect(subject[:use_object_classes][:paths_object]).to eq RoutesToSwaggerDocs::Schema::V3::PathsObject
        expect(subject[:use_object_classes][:path_item_object]).to eq RoutesToSwaggerDocs::Schema::V3::PathItemObject
        expect(subject[:use_object_classes][:external_document_object]).to eq RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject
        expect(subject[:use_object_classes][:components_object]).to eq RoutesToSwaggerDocs::Schema::V3::ComponentsObject
        expect(subject[:use_object_classes][:components_schema_object]).to eq RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject
        expect(subject[:use_object_classes][:components_request_body_object]).to eq RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
        # tool configuraiton
        expect(subject[:tool].paths_stats.month_to_turn_to_warning_color).to eq 3
        expect(subject[:tool].paths_stats.warning_color).to eq :red
        expect(subject[:tool].paths_stats.table_title_color).to eq :yellow
        expect(subject[:tool].paths_stats.heading_color).to eq :yellow
        expect(subject[:tool].paths_stats.highlight_color).to eq :magenta
      end
    end

    context 'when override setting' do
      before do
        class CustomDummy
          extend RoutesToSwaggerDocs::Configuration

          configure do |config|
            config.version = :v4
            config.root_dir_path = "apidocs"
            config.schema_save_dir_name = "files"
            config.doc_save_file_name = "swagger.yml"
            config.force_update_schema = true
            config.use_tag_namespace = true
            config.use_schema_namespace = true
            config.namespace_type = :dot
            config.http_statuses_when_http_method = {
              get: {
                default: %w(200 403),
                path_parameter: %w(200 404 403)
              },
              post: {
                default: %w(201 403),
                path_parameter: %w(201 404 403)
              },
              patch: {
                default: %w(204 403),
                path_parameter: %w(204 404 403)
              },
              put: {
                default: %w(204 403),
                path_parameter: %w(204 404 403)
              },
              delete: {
                default: %w(200 403),
                path_parameter: %w(200 404 403)
              }
            }
            # server configuration
            config.server.data = [
              {
                url: 'http://localhost:3000',
                description: 'main'
              },
              {
                url: 'http://localhost:3001',
                description: 'sub'
              }
            ]
            # swagger configuration
            config.swagger.configure do |swagger|
              swagger.ui.image            = "original/swagger-ui"
              swagger.ui.port             = "9090"
              swagger.ui.exposed_port     = "9090/tcp"
              swagger.ui.volume           = "/app/swagger_doc.json"
              swagger.editor.image        = "original/swagger-editor"
              swagger.editor.port         = "91"
              swagger.editor.exposed_port = "9090/tcp" 
            end
            # object classes
            config.use_object_classes = {
              info_object:                    RtsdInfoObject,
              paths_object:                   RtsdPathsObject,
              path_item_object:               RtsdPathItemObject,
              external_document_object:       RtsdExternalDocumentObject,
              components_object:              RtsdComponentsObject,
              components_schema_object:       Components::RtsdSchemaObject,
              components_request_body_object: Components::RtsdRequestBodyObject
            }
            # tool configuration
            config.tool.paths_stats.configure do |paths_stats|
              paths_stats.month_to_turn_to_warning_color = 6
              paths_stats.warning_color                  = :blue
              paths_stats.table_title_color              = :red
              paths_stats.heading_color                  = :red
              paths_stats.highlight_color                = :yellow
            end
          end
        end
      end

      subject { CustomDummy.options }

      it 'should set correctly' do
        expect(subject[:version]).to eq :v4
        expect(subject[:root_dir_path]).to eq "apidocs"
        expect(subject[:schema_save_dir_name]).to eq "files"
        expect(subject[:doc_save_file_name]).to eq "swagger.yml"
        expect(subject[:force_update_schema]).to eq true
        expect(subject[:use_tag_namespace]).to eq true
        expect(subject[:use_schema_namespace]).to eq true
        expect(subject[:namespace_type]).to eq :dot
        expect(subject[:http_statuses_when_http_method][:get][:default]).to include("200", "403")
        expect(subject[:http_statuses_when_http_method][:get][:path_parameter]).to include("200", "404", "403")
        expect(subject[:http_statuses_when_http_method][:post][:default]).to include("201", "403")
        expect(subject[:http_statuses_when_http_method][:post][:path_parameter]).to include("201", "404", "403")
        expect(subject[:http_statuses_when_http_method][:patch][:default]).to include("204", "403")
        expect(subject[:http_statuses_when_http_method][:patch][:path_parameter]).to include("204", "404", "403")
        expect(subject[:http_statuses_when_http_method][:put][:default]).to include("204", "403")
        expect(subject[:http_statuses_when_http_method][:put][:path_parameter]).to include("204", "404", "403")
        expect(subject[:http_statuses_when_http_method][:delete][:default]).to include("200", "403")
        expect(subject[:http_statuses_when_http_method][:delete][:path_parameter]).to include("200", "404", "403")
        # server configuration
        expect(subject[:server].data[0][:url]).to eq 'http://localhost:3000'
        expect(subject[:server].data[0][:description]).to eq 'main'
        expect(subject[:server].data[1][:url]).to eq 'http://localhost:3001'
        expect(subject[:server].data[1][:description]).to eq 'sub'
        # swagger configuration
        expect(subject[:swagger].ui.image).to eq 'original/swagger-ui'
        expect(subject[:swagger].ui.port).to eq '9090'
        expect(subject[:swagger].ui.exposed_port).to eq '9090/tcp'
        expect(subject[:swagger].ui.volume).to eq '/app/swagger_doc.json'
        expect(subject[:swagger].editor.image).to eq 'original/swagger-editor'
        expect(subject[:swagger].editor.port).to eq '91'
        expect(subject[:swagger].editor.exposed_port).to eq '9090/tcp'
        # object classes
        expect(subject[:use_object_classes][:info_object]).to eq RtsdInfoObject
        expect(subject[:use_object_classes][:paths_object]).to eq RtsdPathsObject
        expect(subject[:use_object_classes][:path_item_object]).to eq RtsdPathItemObject
        expect(subject[:use_object_classes][:external_document_object]).to eq RtsdExternalDocumentObject
        expect(subject[:use_object_classes][:components_object]).to eq RtsdComponentsObject
        expect(subject[:use_object_classes][:components_schema_object]).to eq Components::RtsdSchemaObject
        expect(subject[:use_object_classes][:components_request_body_object]).to eq Components::RtsdRequestBodyObject
        # tool configuraiton
        expect(subject[:tool].paths_stats.month_to_turn_to_warning_color).to eq 6
        expect(subject[:tool].paths_stats.warning_color).to eq :blue
        expect(subject[:tool].paths_stats.table_title_color).to eq :red
        expect(subject[:tool].paths_stats.heading_color).to eq :red
        expect(subject[:tool].paths_stats.highlight_color).to eq :yellow
      end
    end
  end
end