# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/components/schema_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::SchemaObject do
  let(:opts) { {} }
  let(:doc) { { 'properties' => { 'id' => { 'format' => 'int64', 'type' => 'integer' } }, 'type' => 'object' } }
  let(:from) { nil }
  let(:http_status) { nil }
  let(:parent_schema_name) { nil }
  let(:ref_or_data) do
    {
      type: :schema,
      path: '/api/v1/tasks/{id}',
      schema_name: 'Api_V1_Task',
      tag_name: 'api/v1/task',
      verb: 'patch',
      from: from,
      http_status: http_status,
      depth: 0,
      parent_schema_name: parent_schema_name
    }
  end
  let(:object) { described_class.new(doc, ref_or_data, opts) }

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
                    'path_item' => "plugin_value.#{ref.type}.#{ref.path}.#{ref.schema_name}.#{ref.tag_name}.#{ref.verb}.#{ref.http_status}.#{ref.depth}"
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

        it { expect(object.to_doc['path_item']).to eq 'plugin_value.schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0' }
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
                    'request_body' => "plugin_value.#{ref[:type]}.#{ref[:path]}.#{ref[:schema_name]}.#{ref[:tag_name]}.#{ref[:verb]}.#{ref[:http_status]}.#{ref[:depth]}"
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

        it { expect(object.to_doc['request_body']).to eq 'plugin_value.schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0' }
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
                    'schema' => "plugin_value.#{ref[:type]}.#{ref[:path]}.#{ref[:schema_name]}.#{ref[:tag_name]}.#{ref[:verb]}.#{ref[:http_status]}.#{ref[:depth]}"
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
        
        it { expect(object.to_doc['schema']).to eq 'plugin_value.schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0' }
      end
    end
  end
  
  describe '#schema_name (#ref_path)' do
    context 'when default' do
      it do
        expect(object.schema_name).to eq 'Api_V1_Task'
        expect(object.ref_path).to eq '#/components/schemas/Api_V1_Task'
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
                  ref[:schema_name] = "#{ref[:type]}.#{ref[:path]}.#{ref[:schema_name]}.#{ref[:tag_name]}.#{ref[:verb]}.#{ref[:http_status]}.#{ref[:depth]}"
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

        it do
          expect(object.schema_name).to eq 'schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0'
          expect(object.ref_path).to eq '#/components/schemas/schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0'
        end
      end
      
      context 'when reference from :schema' do
        let(:from) { :schema }
        
        before do
          class TestSchemaNameFromSchemaTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-from-schema'

            components_schema_name do |ref|
              if opts[:override]
                if ref[:from] == :schema
                  ref[:schema_name] = "#{ref.type}.#{ref.path}.#{ref.schema_name}.#{ref.tag_name}.#{ref.verb}.#{ref.http_status}.#{ref.depth}"
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
        
        it do
          expect(object.schema_name).to eq 'schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0'
          expect(object.ref_path).to eq '#/components/schemas/schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.204.0'
        end
      end

      context 'when reference from :request_body' do
        let(:from) { :request_body }

        before do
          class TestSchemaNameFromRequestBodyTransform < R2OAS::Plugin::Transform
            self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-from-request-body'

            components_schema_name do |ref|
              if opts[:override]
                if ref[:from] == :request_body
                  ref[:schema_name] = "#{ref[:type]}.#{ref[:path]}.#{ref[:schema_name]}.#{ref[:tag_name]}.#{ref[:verb]}.#{ref[:depth]}"
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

        it do
          expect(object.schema_name).to eq 'schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.0'
          expect(object.ref_path).to eq '#/components/schemas/schema./api/v1/tasks/{id}.Api_V1_Task.api/v1/task.patch.0'
        end
      end
    end
    
    context 'when errors occurs (by using components_schema_name in plugins)' do
      let(:opts) { { use_plugin: true } }
      let(:http_status) { 204 }
      let(:from) { :request_body }
      
      before do
        set_components_schema_name_list(['Api_V1_Task_Used'])
        
        class TestSchemaNameErrorOccursTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name-error-occurs'

          components_schema_name do |ref|
            if opts[:override]
              if ref[:from] == :request_body
                ref[:schema_name] = 'Api_V1_Task_Used'
              end
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-schema-name-error-occurs', { override: true }]
          ]
        end
      end
      
      it do
        expect { object.schema_name }.to raise_error(::R2OAS::DepulicateSchemaNameError, "Transformed schema name: 'Api_V1_Task_Used' cannot be used. It already exists.")
      end
    end
  end
end
