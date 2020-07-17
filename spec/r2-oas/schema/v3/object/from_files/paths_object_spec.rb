# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/paths_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::PathsObject do
  let(:doc) do
    {
      '/tasks' =>
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
              { '204' => { 'description' => 'task description' },
                '404' => { 'description' => 'task description' },
                '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
              'deprecated' => false,
              'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
              'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] } }
    }
  end
  let(:opts) { {} }
  let(:object) { described_class.new(doc, opts) }

  before do
    init
  end

  after do
    delete_oas_docs
  end

  describe '#to_doc' do
    it {
      expect(object.to_doc['/tasks']).to eq 'get' =>
      { 'tags' => ['task'],
        'summary' => 'get summary',
        'description' => 'get description',
        'responses' =>
        { '200' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
          '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
        'deprecated' => false }
    }
    it {
      expect(object.to_doc['/tasks/{id}']).to eq 'patch' =>
      { 'tags' => ['task'],
        'summary' => 'patch summary',
        'description' => 'patch description',
        'responses' =>
        { '204' => { 'description' => 'task description' },
          '404' => { 'description' => 'task description' },
          '422' => { 'description' => 'task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } } },
        'deprecated' => false,
        'requestBody' => { '$ref' => '#/components/requestBodies/Task' },
        'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] }
    }
  end
end
