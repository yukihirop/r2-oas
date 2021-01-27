# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Configuration do
  describe 'configure' do
    context 'when default setting' do
      before do
        class DefaultDummy
          extend R2OAS::Configuration
        end
      end

      subject { DefaultDummy.options }

      it 'should set correctly' do
        expect(subject[:version]).to eq :v3
        expect(subject[:root_dir_path]).to eq './oas_docs'
        expect(subject[:schema_save_dir_name]).to eq 'src'
        expect(subject[:doc_save_file_name]).to eq 'oas_doc.yml'
        expect(subject[:force_update_schema]).to eq false
        expect(subject[:use_tag_namespace]).to eq true
        expect(subject[:use_schema_namespace]).to eq true
        expect(subject[:namespace_type]).to eq :dot
        expect(subject[:deploy_dir_path]).to eq './deploy_docs'
        expect(subject[:http_statuses_when_http_method][:get][:default]).to include('200', '422')
        expect(subject[:http_statuses_when_http_method][:get][:path_parameter]).to include('200', '404', '422')
        expect(subject[:http_statuses_when_http_method][:post][:default]).to include('201', '422')
        expect(subject[:http_statuses_when_http_method][:post][:path_parameter]).to include('201', '404', '422')
        expect(subject[:http_statuses_when_http_method][:patch][:default]).to include('204', '422')
        expect(subject[:http_statuses_when_http_method][:patch][:path_parameter]).to include('204', '404', '422')
        expect(subject[:http_statuses_when_http_method][:put][:default]).to include('204', '422')
        expect(subject[:http_statuses_when_http_method][:put][:path_parameter]).to include('204', '404', '422')
        expect(subject[:http_statuses_when_http_method][:delete][:default]).to include('200', '422')
        expect(subject[:http_statuses_when_http_method][:delete][:path_parameter]).to include('200', '404', '422')
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
        # plugin configuration
        expect(subject[:plugins]).to eq []
        expect(subject[:local_plugins_dir_name]).to eq 'plugins'
        expect(subject[:local_tasks_dir_name]).to eq 'tasks'
        expect(subject[:output_path]).to eq './oas_docs/dist/oas_doc.yml'
        expect(subject[:deprecation].silenced).to eq false
      end
    end

    context 'when override setting' do
      before do
        class CustomDummy
          extend R2OAS::Configuration

          configure do |config|
            config.version = :v4
            config.root_dir_path = 'apidocs'
            config.schema_save_dir_name = 'files'
            config.doc_save_file_name = 'swagger.yml'
            config.force_update_schema = true
            config.use_tag_namespace = true
            config.use_schema_namespace = true
            config.namespace_type = :underbar
            config.deploy_dir_path = 'dist_docs'
            config.http_statuses_when_http_method = {
              get: {
                default: %w[200 403],
                path_parameter: %w[200 404 403]
              },
              post: {
                default: %w[201 403],
                path_parameter: %w[201 404 403]
              },
              patch: {
                default: %w[204 403],
                path_parameter: %w[204 404 403]
              },
              put: {
                default: %w[204 403],
                path_parameter: %w[204 404 403]
              },
              delete: {
                default: %w[200 403],
                path_parameter: %w[200 404 403]
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
              swagger.ui.image            = 'original/swagger-ui'
              swagger.ui.port             = '9090'
              swagger.ui.exposed_port     = '9090/tcp'
              swagger.ui.volume           = '/app/oas_doc.json'
              swagger.editor.image        = 'original/swagger-editor'
              swagger.editor.port         = '91'
              swagger.editor.exposed_port = '9090/tcp'
            end
            # plugins configuration
            config.plugins = [
              ['r2oas-plugin-transform-sample', { loose: false }],
              'r2oas-plugin-transform-sample2'
            ]
            config.local_plugins_dir_name = 'plugins'
            config.local_tasks_dir_name = 'rake_tasks'
            config.output_path = './dist/oas_doc.yml'
            config.deprecation.silenced = true
          end
        end
      end

      subject { CustomDummy.options }

      it 'should set correctly' do
        expect(subject[:version]).to eq :v4
        expect(subject[:root_dir_path]).to eq 'apidocs'
        expect(subject[:schema_save_dir_name]).to eq 'files'
        expect(subject[:doc_save_file_name]).to eq 'swagger.yml'
        expect(subject[:force_update_schema]).to eq true
        expect(subject[:use_tag_namespace]).to eq true
        expect(subject[:use_schema_namespace]).to eq true
        expect(subject[:namespace_type]).to eq :underbar
        expect(subject[:deploy_dir_path]).to eq 'dist_docs'
        expect(subject[:http_statuses_when_http_method][:get][:default]).to include('200', '403')
        expect(subject[:http_statuses_when_http_method][:get][:path_parameter]).to include('200', '404', '403')
        expect(subject[:http_statuses_when_http_method][:post][:default]).to include('201', '403')
        expect(subject[:http_statuses_when_http_method][:post][:path_parameter]).to include('201', '404', '403')
        expect(subject[:http_statuses_when_http_method][:patch][:default]).to include('204', '403')
        expect(subject[:http_statuses_when_http_method][:patch][:path_parameter]).to include('204', '404', '403')
        expect(subject[:http_statuses_when_http_method][:put][:default]).to include('204', '403')
        expect(subject[:http_statuses_when_http_method][:put][:path_parameter]).to include('204', '404', '403')
        expect(subject[:http_statuses_when_http_method][:delete][:default]).to include('200', '403')
        expect(subject[:http_statuses_when_http_method][:delete][:path_parameter]).to include('200', '404', '403')
        expect(subject[:ignored_http_statuses_when_generate_component_schema]).to include('204', '404')
        # server configuration
        expect(subject[:server].data[0][:url]).to eq 'http://localhost:3000'
        expect(subject[:server].data[0][:description]).to eq 'main'
        expect(subject[:server].data[1][:url]).to eq 'http://localhost:3001'
        expect(subject[:server].data[1][:description]).to eq 'sub'
        # swagger configuration
        expect(subject[:swagger].ui.image).to eq 'original/swagger-ui'
        expect(subject[:swagger].ui.port).to eq '9090'
        expect(subject[:swagger].ui.exposed_port).to eq '9090/tcp'
        expect(subject[:swagger].ui.volume).to eq '/app/oas_doc.json'
        expect(subject[:swagger].editor.image).to eq 'original/swagger-editor'
        expect(subject[:swagger].editor.port).to eq '91'
        expect(subject[:swagger].editor.exposed_port).to eq '9090/tcp'
        # plugin configuration
        expect(subject[:plugins]).to include(
          ['r2oas-plugin-transform-sample', { loose: false }],
          'r2oas-plugin-transform-sample2'
        )
        expect(subject[:local_plugins_dir_name]).to eq 'plugins'
        expect(subject[:local_tasks_dir_name]).to eq 'rake_tasks'
        expect(subject[:output_path]).to eq './dist/oas_doc.yml'
        expect(subject[:deprecation].silenced).to eq true
      end
    end
  end
end
