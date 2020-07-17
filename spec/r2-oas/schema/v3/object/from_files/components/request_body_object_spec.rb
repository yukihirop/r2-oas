# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/components/request_body_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::RequestBodyObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:opts) { {} }
  let(:ref) { { path: path, schema_name: 'Api_V1_Task', verb: :get, tag_name: 'api/v1/task', from: :path_item } }
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
                  'plugin_key' => "plugin_value_#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}"
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

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value_/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_get' }
    end

    context 'when use plugins (components_request_body_name)' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestRequestBodyNameTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-request-body-name'

          components_request_body_name do |ref|
            if opts[:override]
              ref[:schema_name] = "#{ref[:path]}_#{ref[:tag_name]}_#{ref[:verb]}" if ref[:from] == :path_item
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-request-body-name', { override: true }]
          ]
        end
      end

      it { expect(object.schema_name).to eq '/api/v1/tasks/{id}_api/v1/task_get' }
    end
  end
end
