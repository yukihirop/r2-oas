# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_routes/openapi_object'

RSpec.describe R2OAS::Schema::V3::OpenapiObject do
  let(:routes_data) do
    [
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
      { data: { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }, path: '/api/v1/tasks/{id}' }
    ]
  end
  let(:tags_data) { ['task', 'api/v1/task'] }
  let(:schemas_data) { %w[Task Api_V1_Task] }
  let(:opts) { {} }
  let(:object) { described_class.new(routes_data, tags_data, schemas_data, opts) }

  let(:info_doc) { double('InfoObject#to_doc') }
  let(:tag_doc) { double('TagObject#to_doc') }
  let(:paths_doc) { double('PathsObject#to_doc') }
  let(:external_docs_doc) { double('ExternalDocumentObject#to_doc') }
  let(:servers_doc) { double('ServerObject#to_doc') }
  let(:components_doc) { double('ComponentsObject#to_doc') }

  describe '#to_doc' do
    before do
      allow_any_instance_of(R2OAS::Schema::V3::InfoObject).to receive(:to_doc).and_return(info_doc)
      allow_any_instance_of(R2OAS::Schema::V3::TagObject).to receive(:to_doc).and_return(tag_doc)
      allow_any_instance_of(R2OAS::Schema::V3::PathsObject).to receive(:to_doc).and_return(paths_doc)
      allow_any_instance_of(R2OAS::Schema::V3::ExternalDocumentObject).to receive(:to_doc).and_return(external_docs_doc)
      allow_any_instance_of(R2OAS::Schema::V3::ServerObject).to receive(:to_doc).and_return(servers_doc)
      allow_any_instance_of(R2OAS::Schema::V3::ComponentsObject).to receive(:to_doc).and_return(components_doc)
    end
    context 'when default' do
      it { expect(object.to_doc['openapi']).to eq '3.0.0' }
      it { expect(object.to_doc['info']).to eq info_doc }
      it { expect(object.to_doc['tags']).to eq tag_doc }
      it { expect(object.to_doc['paths']).to eq paths_doc }
      it { expect(object.to_doc['externalDocs']).to eq external_docs_doc }
      it { expect(object.to_doc['servers']).to eq servers_doc }
      it { expect(object.to_doc['components']).to eq components_doc }
    end
  end
end
