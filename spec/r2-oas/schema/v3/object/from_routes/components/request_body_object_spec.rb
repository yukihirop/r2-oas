# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::Components::RequestBodyObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }
  end
  let(:opts) { {} }
  let(:object) { described_class.new(route_data, path, opts) }

  before do
    init
  end

  after do
    delete_oas_docs
  end

  describe '#to_doc' do
    context 'when default' do
      it do
        expect(object.to_doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } },
                                    'has_one' =>
         { 'type' => 'schema',
           'original_path' => '#/components/schemas/Api_V1_Task',
           'data' => { 'components' => { 'schemas' => { 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } } } } }
      end
    end
  end

  describe '#create_doc (private)' do
    before do
      object.send(:create_doc)
    end

    it do
      expect(object.doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } }
    end
  end
end
