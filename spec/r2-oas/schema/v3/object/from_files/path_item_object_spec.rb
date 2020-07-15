# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/path_item_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::PathItemObject do
  let(:doc) do
    {
      'delete' =>
          { 'tags' => ['api/v1/task'],
            'summary' => 'delete summary',
            'description' => 'delete description',
            'responses' =>
            { '200' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } },
              '404' => { 'description' => 'api/v1/task description' },
              '422' => { 'description' => 'api/v1/task description', 'content' => { 'application/json' => { 'schema' => { '$ref' => '#/components/schemas/Api_V1_Task' } } } } },
            'deprecated' => false,
            'parameters' => [{ 'name' => 'id', 'in' => 'path', 'description' => 'id', 'required' => true, 'schema' => { 'type' => 'integer' } }] }
    }
  end
  let(:ref) { { path: '/api/v1/tasks/{id}' } }
  let(:opts) { {} }
  let(:object) { described_class.new(doc, ref, opts) }

  describe '#to_doc' do
    context 'when use plugins' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestPathItemTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-path-item'

          path_item do |doc, ref|
            if opts[:merged]
              doc.merge!(
                'plugin_key' => "plugin_value_#{ref[:path]}"
              )
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-path-item', { merged: true }]
          ]
        end
      end

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value_/api/v1/tasks/{id}' }
    end
  end
end
