# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::PathsObject do
  let(:routes_data) { [] }
  let(:object) { R2OAS.use_object_classes[:paths_object].new(routes_data) }

  before do
    create_dot_paths
  end

  after do
    reset_config
    # TODO: remove this method
    delete_oas_docs
  end

  describe '#to_doc' do
    context 'when use before_create && after_create' do
      before do
        class TestPathsObject < R2OAS::Schema::V3::PathsObject
          before_create do |doc, _path|
            doc.merge!(
              'before_key' => 'before_value'
            )
          end

          after_create do |doc, _path|
            doc.merge!(
              'after_key' => 'after_value'
            )
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            paths_object: TestPathsObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

  describe '#create_doc' do
    context 'when namespace_type is :underbar' do
      let(:routes_data) do
        [
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'post' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks/new', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/new' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}' }
        ]
      end

      it do
        expect(object.create_doc).to eq '/tasks' =>
            { 'get' =>
              { 'tags' => ['task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
                'deprecated' => false } },
                                        '/tasks/{id}' =>
            { 'patch' =>
              { 'tags' => ['task'],
                'summary' => 'patch summary',
                'description' => 'patch description',
                'responses' =>
                { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
                'deprecated' => false,
                'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
                'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } },
                                        '/api/v1/tasks' =>
            { 'get' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
                'deprecated' => false },
              'post' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'post summary',
                'description' => 'post description',
                'responses' =>
                { '201' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
                'deprecated' => false,
                'requestBody' => { '$ref' => '#/components/requestBodies/Api_V1_Task' } } },
                                        '/api/v1/tasks/new' =>
            { 'get' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
                'deprecated' => false } },
                                        '/api/v1/tasks/{id}' =>
            { 'delete' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'delete summary',
                'description' => 'delete description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
                  '404' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
                'deprecated' => false,
                'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } }
      end
    end

    context 'when namespace_type is :dot' do
      let(:routes_data) do
        [
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'post' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks/new', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/new' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}' }
        ]
      end

      it do
        expect(object.create_doc).to eq '/tasks' =>
            { 'get' =>
              { 'tags' => ['task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
                'deprecated' => false } },
                                        '/tasks/{id}' =>
            { 'patch' =>
              { 'tags' => ['task'],
                'summary' => 'patch summary',
                'description' => 'patch description',
                'responses' =>
                { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                  '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
                'deprecated' => false,
                'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
                'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } },
                                        '/api/v1/tasks' =>
            { 'get' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } } },
                'deprecated' => false },
              'post' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'post summary',
                'description' => 'post description',
                'responses' =>
                { '201' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } } },
                'deprecated' => false,
                'requestBody' => { '$ref' => '#/components/requestBodies/api.v1.Task' } } },
                                        '/api/v1/tasks/new' =>
            { 'get' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'get summary',
                'description' => 'get description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } } },
                'deprecated' => false } },
                                        '/api/v1/tasks/{id}' =>
            { 'delete' =>
              { 'tags' => ['api/v1/task'],
                'summary' => 'delete summary',
                'description' => 'delete description',
                'responses' =>
                { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } },
                  '404' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } },
                  '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/api.v1.Task' } } } } },
                'deprecated' => false,
                'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } }
      end
    end

    context 'when http_methods_when_generate_request_body is configured' do
      let(:routes_data) do
        [
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'post' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'put' }, path: '/tasks/{id}' }
        ]
      end

      before do
        R2OAS.configure do |config|
          config.http_methods_when_generate_request_body = %w[post]
        end
      end

      it do
        expect(object.create_doc).to eq '/tasks' =>
          { 'post' =>
            { 'tags' => ['task'],
              'summary' => 'post summary',
              'description' => 'post description',
              'responses' =>
              { '201' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'requestBody' => { '$ref' => '#/components/requestBodies/Task' } } },
                                        '/tasks/{id}' =>
          { 'patch' =>
            { 'tags' => ['task'],
              'summary' => 'patch summary',
              'description' => 'patch description',
              'responses' =>
              { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] },
            'put' =>
            { 'tags' => ['task'],
              'summary' => 'put summary',
              'description' => 'put description',
              'responses' =>
              { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } }
      end
    end

    context 'when http_statuses_when_http_method is configured' do
      let(:routes_data) do
        [
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'post' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/new', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/new' },
          { data: { format_name: '', path: '/tasks/{id}/edit', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}/edit' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'put' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'delete' }, path: '/tasks/{id}' }
        ]
      end

      before do
        R2OAS.configure do |config|
          config.http_statuses_when_http_method = {
            get: {
              default: %w[200],
              path_parameter: %w[200 404]
            },
            post: {
              default: %w[201],
              path_parameter: %w[201 404]
            },
            patch: {
              default: %w[204],
              path_parameter: %w[204 404]
            },
            put: {
              default: %w[204],
              path_parameter: %w[204 404]
            },
            delete: {
              default: %w[200],
              path_parameter: %w[200 404]
            }
          }
        end
      end

      it do
        expect(object.create_doc).to eq '/tasks' =>
          { 'get' =>
            { 'tags' => ['task'],
              'summary' => 'get summary',
              'description' => 'get description',
              'responses' => { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false },
            'post' =>
            { 'tags' => ['task'],
              'summary' => 'post summary',
              'description' => 'post description',
              'responses' => { '201' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'requestBody' => { '$ref' => '#/components/requestBodies/Task' } } },
                                        '/tasks/new' =>
          { 'get' =>
            { 'tags' => ['task'],
              'summary' => 'get summary',
              'description' => 'get description',
              'responses' => { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false } },
                                        '/tasks/{id}/edit' =>
          { 'get' =>
            { 'tags' => ['task'],
              'summary' => 'get summary',
              'description' => 'get description',
              'responses' =>
              { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } },
                                        '/tasks/{id}' =>
          { 'get' =>
            { 'tags' => ['task'],
              'summary' => 'get summary',
              'description' => 'get description',
              'responses' =>
              { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] },
            'patch' =>
            { 'tags' => ['task'],
              'summary' => 'patch summary',
              'description' => 'patch description',
              'responses' =>
              { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] },
            'put' =>
            { 'tags' => ['task'],
              'summary' => 'put summary',
              'description' => 'put description',
              'responses' =>
              { '204' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] },
            'delete' =>
            { 'tags' => ['task'],
              'summary' => 'delete summary',
              'description' => 'delete description',
              'responses' =>
              { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                '404' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } }
      end
    end
  end
end
