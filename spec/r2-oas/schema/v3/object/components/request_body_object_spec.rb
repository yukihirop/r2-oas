# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::Components::RequestBodyObject do
  let(:path) { '/api/v1/tasks/{id}' }
  let(:route_data) do
    { format_name: '', path: '/api/v1/tasks/{id}', required_parameters: { id: { type: 'integer' } }, schema_name: 'Api_V1_Task', tag_name: 'api/v1/task', verb: 'patch' }
  end
  let(:object) { R2OAS.use_object_classes[:components_request_body_object].new(route_data, path) }

  before do
    create_dot_paths
  end

  after do
    reset_config
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

    context 'when use before_create && after_create' do
      before do
        module Components
          class TestRequestBodyObject < R2OAS::Schema::V3::Components::RequestBodyObject
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
            components_request_body_object: Components::TestRequestBodyObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

  describe '#create_doc' do
    before do
      object.create_doc
    end

    it do
      expect(object.doc).to eq 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } }
    end
  end
end
