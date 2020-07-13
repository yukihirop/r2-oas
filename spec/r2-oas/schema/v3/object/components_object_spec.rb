# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::ComponentsObject do
  let(:routes_data) do
    [
      { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
      { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'post' }, path: '/tasks' },
      { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }, path: '/api/v1/tasks/{id}' },
      { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'put' }, path: '/api/v1/tasks/{id}' },
      { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}' }
    ]
  end
  let(:object) { R2OAS.use_object_classes[:components_object].new(routes_data) }

  before do
    create_dot_paths
  end

  after do
    reset_config
    delete_oas_docs
  end

  describe '#to_doc' do
    context 'when use before_create && after_create' do
      before do
        class TestComponentsObject < R2OAS::Schema::V3::ComponentsObject
          before_create do |doc|
            doc.merge!(
              'before_key' => 'before_value'
            )
          end

          after_create do |doc|
            doc.merge!(
              'after_key' => 'after_value'
            )
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            components_object: TestComponentsObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

  describe '#create_doc' do
    context 'when default' do
      it do
        expect(object.create_doc).to eq 'schemas' => { 'Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } }, 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } },
                                        'requestBodies' =>
         { 'Task' =>
           { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } },
             'has_one' =>
             { 'type' => 'schema', 'original_path' => '#/components/schemas/Task', 'data' => { 'components' => { 'schemas' => { 'Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } } } } } },
           'Api_V1_Task' =>
           { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } },
             'has_one' =>
             { 'type' => 'schema',
               'original_path' => '#/components/schemas/Api_V1_Task',
               'data' => { 'components' => { 'schemas' => { 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } } } } } } }
      end
    end
  end
end
