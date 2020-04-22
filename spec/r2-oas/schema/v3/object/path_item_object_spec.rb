# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::PathItemObject do
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'delete' }
  end
  let(:path) { '/api/v1/tasks/{id}' }
  let(:object) { R2OAS.use_object_classes[:path_item_object].new(route_data, path) }

  after do
    reset_config
  end

  describe '#to_doc' do
    context 'when use before_create && after_create' do
      before do
        class TestPathItemObject < R2OAS::Schema::V3::PathItemObject
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
            path_item_object: TestPathItemObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

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
