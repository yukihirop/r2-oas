# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/components/request_body_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::RequestBodyObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:opts) { {} }
  let(:ref) do
    {
      type: :request_body,
      path: path,
      schema_name: 'Api_V1_Task_RequestBody',
      verb: :patch,
      tag_name: 'api/v1/task',
      from: :path_item,
      depth: 0
    }
  end
  let(:doc) do
    { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } }
  end
  let(:object) { described_class.new(doc, ref, opts) }

  before do
    init
  end

  after do
    delete_oas_docs
  end

  describe '#to_doc' do
    context 'when default' do
      it do
        expect(object.to_doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } }
      end
    end

    context 'when use plugins (components_request_body)' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestRequestBodyTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body'

          components_request_body do |doc, ref|
            if opts[:merged]
              if ref[:from] == :path_item
                doc.merge!(
                  'plugin_key' => "plugin_value.#{ref.type}.#{ref.path}.#{ref.schema_name}.#{ref.tag_name}.#{ref.verb}.#{ref.depth}"
                )
              end
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body', { merged: true }]
          ]
        end
      end

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value.request_body./api/v1/tasks/{id}.Api_V1_Task_RequestBody.api/v1/task.patch.0' }
    end
  end

  describe '#schema_name (#ref_path)' do
    context 'when default' do
      it do
        expect(object.schema_name).to eq 'Api_V1_Task_RequestBody'
        expect(object.ref_path).to eq '#/components/requestBodies/Api_V1_Task_RequestBody'
      end
    end

    context 'when use plugins (components_request_body_name)' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestRequestBodyNameTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body-name'

          components_request_body_name do |ref|
            if opts[:override]
              ref[:schema_name] = "#{ref[:type]}.#{ref[:path]}.#{ref[:tag_name]}.#{ref[:verb]}.#{ref[:depth]}" if ref[:from] == :path_item
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body-name', { override: true }]
          ]
        end
      end

      it do
        expect(object.schema_name).to eq 'request_body./api/v1/tasks/{id}.api/v1/task.patch.0'
        expect(object.ref_path).to eq '#/components/requestBodies/request_body./api/v1/tasks/{id}.api/v1/task.patch.0'
      end
    end

    context 'when errors occurs (by using components_request_body_name in plugins)' do
      let(:opts) { { use_plugin: true } }
      let(:from) { :path_item }

      before do
        set_components_request_body_name_list(['Api_V1_Task_RequestBody_Used'])

        class TestRequestBodyNameErrorOccursTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body-name-error-occurs'

          components_request_body_name do |ref|
            if opts[:override]
              ref[:schema_name] = 'Api_V1_Task_RequestBody_Used' if ref[:from] == :path_item
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body-name-error-occurs', { override: true }]
          ]
        end
      end

      it do
        expect { object.schema_name }.to raise_error(::R2OAS::DepulicateSchemaNameError, "Transformed schema name: 'Api_V1_Task_RequestBody_Used' cannot be used. It already exists.")
      end
    end
  end
end
