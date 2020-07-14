# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::Components::SchemaObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }
  end
  let(:opts) { {} }
  let(:object) { R2OAS.use_object_classes[:components_schema_object].new(route_data, path, opts) }

  before do
    create_dot_paths
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

    context 'when use before_create && after_create' do
      before do
        module Components
          class TestSchemaObject < R2OAS::Schema::V3::Components::SchemaObject
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
            components_schema_object: Components::TestSchemaObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end

    context 'when use plugins (components_schema)' do
      let(:opts) { { use_plugin: true } }

      before do
        class Components::TestSchemaTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-schema'

          components_schema do |doc, schema_name|
            if opts[:merged]
              doc.merge!(
                'plugin_key' => "plugin_value_#{schema_name}"
              )
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-schema', { merged: true }]
          ]
        end
      end

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value_Api_V1_Task' }
    end

    context 'when use plugins (components_schema_name)' do
      let(:opts) { { use_plugin: true } }

      before do
        class Components::TestSchemaNameTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-components-schema-name'

          components_schema_name do |ref, _doc, _path_component, tag_name, verb, http_status|
            ref[:schema_name] = "#{ref[:schema_name]}_#{tag_name}_#{verb}_#{http_status}" if opts[:override]
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-components-schema-name', { override: true }]
          ]
        end
      end

      it { expect(object.send(:_components_schema_name, '204')).to eq 'Api_V1_Task_api/v1/task_patch_204' }
    end
  end

  describe '#create_doc (private)' do
    it do
      expect(object.send(:create_doc)).to eq 'properties' => { 'id' => { 'format' => 'int64', 'type' => 'integer' } }, 'type' => 'object'
    end
  end

  describe '#components_schema_name' do
    before do
      module Components
        class TestSchemaObject2 < R2OAS::Schema::V3::Components::SchemaObject
          NS_DIV = '_'
          # e.x.)
          # GET(200) /v1/tasks/{id} => V1_Task_P1_GET_200
          def components_schema_name(_doc, path_component, tag_name, verb, http_status, _schema_name)
            path_parameters_count = path_component.path_parameters.count
            excluded_path_parameters = path_component.path_excluded_path_parameters
            excluded_path_parameters_arr = excluded_path_parameters.split('/').delete_if(&:empty?)
            base_schema_name = excluded_path_parameters.split('/').map(&:singularize).map(&:camelize).join(NS_DIV)

            base_schema_name = tag_name.split('/').map(&:singularize).map(&:camelize).join(NS_DIV) + base_schema_name if excluded_path_parameters.eql? '' || excluded_path_parameters_arr.count == 1

            if path_parameters_count.zero?
              [base_schema_name, verb.upcase, http_status].join(NS_DIV)
            else
              [base_schema_name, "P#{path_parameters_count}", verb.upcase, http_status].join(NS_DIV)
            end
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            components_schema_object: Components::TestSchemaObject2
          )
        end
      end
    end

    it do
      expect(object.send(:_components_schema_name, '204')).to eq 'Api_V1_Task_P1_PATCH_204'
    end
  end
end
