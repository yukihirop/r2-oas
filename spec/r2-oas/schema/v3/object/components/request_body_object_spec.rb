# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::Components::RequestBodyObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }
  end
  let(:opts) { {} }
  let(:object) { R2OAS.use_object_classes[:components_request_body_object].new(route_data, path, opts) }

  before do
    create_dot_paths
  end

  after do
    delete_oas_docs
  end

  describe '#to_doc' do
    context 'when default' do
      it do
        expect(object.to_doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } },
                                    'has_one' =>
         { 'type' => 'schema',
           'original_path' => '#/components/schemas/Api_V1_Task',
           'data' => { 'components' => { 'schemas' => { 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } } } } }
      end
    end

    context 'when use before_create && after_create' do
      before do
        module Components
          class TestRequestBodyObject < R2OAS::Schema::V3::Components::RequestBodyObject
            before_create do |doc, _schema_name|
              doc.merge!(
                'before_key' => 'before_value'
              )
            end

            after_create do |doc, _schema_name|
              doc.merge!(
                'after_key' => 'after_value'
              )
            end
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            components_request_body_object: Components::TestRequestBodyObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end

    context 'when use plugins (components_request_body)' do
      let(:opts) { { use_plugin: true } }

      before do
        class Components::TestRequestBodyTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body'

          components_request_body do |doc, schema_name|
            if opts[:merged]
              doc.merge!(
                'plugin_key' => "plugin_value_#{schema_name}"
              )
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body', { merged: true }]
          ]
        end
      end

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value_Api_V1_Task' }
    end

    context 'when use plugins (components_request_body_name)' do
      let(:opts) { { use_plugin: true } }

      before do
        class Components::TestRequestBodyNameTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body-name'

          components_request_body_name do |ref, _doc, _path_component, tag_name, verb|
            ref[:schema_name] = "#{ref[:schema_name]}_#{tag_name}_#{verb}" if opts[:override]
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body-name', { override: true }]
          ]
        end
      end

      it { expect(object.send(:_components_request_body_name)).to eq 'Api_V1_Task_api/v1/task_patch' }
    end

    context 'when use plugins (components_schema_name_at_request_body)' do
      let(:opts) { { use_plugin: true } }

      before do
        class Components::TestSchemaNameAtRequestBodyTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-at-request-body'

          components_schema_name_at_request_body do |ref, _doc, _path_component, tag_name, verb|
            ref[:schema_name] = "#{ref[:schema_name]}_#{tag_name}_#{verb}" if opts[:override]
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-schema-name-at-request-body', { override: true }]
          ]
        end
      end

      it { expect(object.send(:_components_schema_name)).to eq 'Api_V1_Task_api/v1/task_patch' }
    end
  end

  describe '#create_doc (private)' do
    before do
      object.send(:create_doc)
    end

    it do
      expect(object.doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } }
    end
  end
end
