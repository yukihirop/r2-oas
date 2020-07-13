# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/routing/parser'

RSpec.describe R2OAS::Routing::Parser do
  let(:routes) { ::Rails.application.routes.routes }
  let(:parser) { described_class.new(routes) }

  after do
    reset_config
  end

  describe '#routes_data' do
    context 'when namespace_type is :underbar' do
      before do
        allow(R2OAS).to receive(:namespace_type).and_return(:underbar)
        allow(R2OAS).to receive(:use_schema_namespace).and_return(true)
      end

      it 'should return routes data' do
        expect(parser.routes_data).to include(
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'post' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/new', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/new' },
          { data: { format_name: '', path: '/tasks/{id}/edit', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}/edit' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'put' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'delete' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'post' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks/new', required_parameters: {}, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/new' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}/edit', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/{id}/edit' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }, path: '/api/v1/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'put' }, path: '/api/v1/tasks/{id}' },
          data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}'
        )
      end
    end

    context 'when namespace_type is :dot' do
      before do
        allow(R2OAS).to receive(:namespace_type).and_return(:dot)
        allow(R2OAS).to receive(:use_schema_namespace).and_return(true)
      end

      it 'should return routes data' do
        expect(parser.routes_data).to include(
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'post' }, path: '/tasks' },
          { data: { format_name: '', path: '/tasks/new', required_parameters: {}, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/new' },
          { data: { format_name: '', path: '/tasks/{id}/edit', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}/edit' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'get' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'patch' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'put' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Task', tag_name: 'task', verb: 'delete' }, path: '/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'post' }, path: '/api/v1/tasks' },
          { data: { format_name: '', path: '/api/v1/tasks/new', required_parameters: {}, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/new' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}/edit', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/{id}/edit' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'get' }, path: '/api/v1/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'patch' }, path: '/api/v1/tasks/{id}' },
          { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'put' }, path: '/api/v1/tasks/{id}' },
          data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'api.v1.Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}'
        )
      end
    end
  end

  describe '#tags_data' do
    it 'should return tags data' do
      expect(parser.tags_data).to include('task', 'api/v1/task')
    end
  end

  describe '#schemas_data' do
    context 'when namespace_type is :underbar' do
      before do
        allow(R2OAS).to receive(:namespace_type).and_return(:underbar)
        allow(R2OAS).to receive(:use_schema_namespace).and_return(true)
      end

      it 'should return schemas data' do
        expect(parser.schemas_data).to include('Task', 'Api_V1_Task')
      end
    end

    context 'when namespace_type is :dot' do
      before do
        allow(R2OAS).to receive(:namespace_type).and_return(:dot)
        allow(R2OAS).to receive(:use_schema_namespace).and_return(true)
      end

      it 'should return schemas data' do
        expect(parser.schemas_data).to include('Task', 'api.v1.Task')
      end
    end
  end
end
