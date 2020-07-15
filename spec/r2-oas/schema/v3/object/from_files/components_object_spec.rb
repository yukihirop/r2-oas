# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/components_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::ComponentsObject do
  let(:opts) { {} }
  let(:doc) do
    {
      'schemas' => { 'Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } }, 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } } },
      'requestBodies' => {
        'Task' =>
           { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
        'Api_V1_Task' =>
           { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } }
      }
    }
  end
  let(:object) { described_class.new(doc, opts) }

  before do
    create_dot_paths
  end

  after do
    delete_oas_docs
  end

  describe '#to_doc' do
    it do
      expect(object.to_doc['schemas']).to eq 'Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } }, 'Api_V1_Task' => { 'type' => 'object', 'properties' => { 'id' => { 'type' => 'integer', 'format' => 'int64' } } }
    end
    it do
      expect(object.to_doc['requestBodies']).to eq  'Task' =>
        { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Task' } } } },
                                                    'Api_V1_Task' =>
         { 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } }
    end
  end
end
