# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/components/schema_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::SchemaObject do
  let(:opts) { {} }
  let(:doc) { { 'properties' => { 'id' => { 'format' => 'int64', 'type' => 'integer' } }, 'type' => 'object' } }
  let(:from) { nil }
  let(:http_status) { nil }
  let(:ref) { { path: '/api/v1/tasks/{id}', schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch', from: from, http_status: http_status } }
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
        expect(object.to_doc).to eq 'properties' => { 'id' => { 'format' => 'int64', 'type' => 'integer' } }, 'type' => 'object'
      end
    end

    context 'when use plugins (components_schema)' do
      let(:opts) { { use_plugin: true } }
      let(:http_status) { 204 }

      context 'when reference from :path_item' do
        let(:from) { :path_item }

        before do
          class TestSchemaFromPathItemTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-from-path-item'

            components_schema do |doc, ref|
              if opts[:merged]
                if ref[:from] == :path_item
                  doc.merge!(
                    'path_item' => "plugin_value_#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}_#{ref[:http_status]}"
                  )
                end
              end
            end
          end

          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-from-path-item', { merged: true }]
            ]
          end
        end

        it { expect(object.to_doc['path_item']).to eq 'plugin_value_/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch_204' }
      end

      context 'when reference from :request_body' do
        let(:from) { :request_body }

        before do
          class TestSchemaFromRequestBodyTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-from-request-body'

            components_schema do |doc, ref|
              if opts[:merged]
                if ref[:from] == :request_body
                  doc.merge!(
                    'request_body' => "plugin_value_#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}"
                  )
                end
              end
            end
          end

          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-from-request-body', { merged: true }]
            ]
          end
        end

        it { expect(object.to_doc['request_body']).to eq 'plugin_value_/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch' }
      end
      
      context 'when reference from :schema' do
        let(:from) { :schema }
        
        before do
          class TestSchemaFromSchemaTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-from-schema'
            
            components_schema do |doc, ref|
              if opts[:merged]
                if ref[:from] == :schema
                  doc.merge!(
                    'schema' => "plugin_value_#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}"
                  )
                end
              end
            end
          end
          
          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-from-schema', { merged: true }]
            ]
          end
        end
        
        it { expect(object.to_doc['schema']).to eq 'plugin_value_/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch' }
      end
    end

    context 'when use plugins (components_schema_name)' do
      let(:opts) { { use_plugin: true } }
      let(:http_status) { 204 }

      context 'when reference from :path_item' do
        let(:from) { :path_item }

        before do
          class TestSchemaNameFromPathItemTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-from-path-item'

            components_schema_name do |ref|
              if opts[:override]
                if ref[:from] == :path_item
                  ref[:schema_name] = "#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}_#{ref[:http_status]}"
                end
              end
            end
          end

          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-name-from-path-item', { override: true }]
            ]
          end
        end

        it { expect(object.schema_name).to eq '/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch_204' }
      end
      
      context 'when reference from :schema' do
        let(:from) { :schema }
        
        before do
          class TestSchemaNameFromSchemaTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-from-schema'

            components_schema_name do |ref|
              if opts[:override]
                if ref[:from] == :schema
                  ref[:schema_name] = "#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}_#{ref[:http_status]}"
                end
              end
            end
          end
          
          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-name-from-schema', { override: true }]
            ]
          end
        end
        
        it { expect(object.schema_name).to eq '/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch_204' }
      end

      context 'when reference from :request_body' do
        let(:from) { :request_body }

        before do
          class TestSchemaNameFromRequestBodyTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-from-request-body'

            components_schema_name do |ref|
              if opts[:override]
                if ref[:from] == :request_body
                  ref[:schema_name] = "#{ref[:path]}_#{ref[:schema_name]}_#{ref[:tag_name]}_#{ref[:verb]}"
                end
              end
            end
          end

          R2OAS.configure do |config|
            config.plugins = [
              ['r2oas-plugin-transform-test-components-schema-name-from-request-body', { override: true }]
            ]
          end
        end

        it { expect(object.schema_name).to eq '/api/v1/tasks/{id}_Api_V1_Task_api/v1/task_patch' }
      end
    end
  end
end
