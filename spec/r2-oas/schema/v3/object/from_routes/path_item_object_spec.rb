# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::PathItemObject do
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }
  end
  let(:path) { '/api/v1/tasks/{id}' }
  let(:object) { described_class.new(route_data, path) }

  describe '#create_doc' do
    it do
      expect(object.create_doc).to eq 'delete' =>
        { 'tags' => ['api/v1/task'],
          'summary' => 'delete summary',
          'description' => 'delete description',
          'responses' =>
          { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
            '404' => { 'description' => 'api/v1/task description' },
            '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
          'deprecated' => false,
          'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] }
    end
  end
end
