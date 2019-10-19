# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::BaseFileManager do
  let(:path) { '#/components/schemas/Dummy' }
  let(:path_type) { :ref }
  let(:manager) { described_class.new(path, path_type) }

  after do
    delete_oas_docs
  end

  describe '#delete' do
    before do
      create_dir('components/schemas')
      create_dummy_components_schemas_file
    end

    it do
      expect { manager.delete }.to change { FileTest.exists?("#{components_schemas_path}/dummy.yml") }.from(true).to(false)
    end
  end

  describe '#save' do
    before do
      manager.save("---\nDummy: dummy")
    end

    it { expect(YAML.load_file("#{components_schemas_path}/dummy.yml")).to eq 'Dummy' => 'dummy' }
  end

  describe '#save_after_deep_merge' do
    let(:data) { { 'externalDocs' => { 'description' => 'example API', 'url' => 'https://example.com' } } }
    let(:path) { 'external_docs' }
    let(:path_type) { :relative }

    before do
      create_dir
      create_dummy_external_document_file("---\nexternalDocs:\n  description: \n  url: \n")
    end

    it do
      expect { manager.save_after_deep_merge(data) }.to change {
        YAML.load_file("#{src_path}/external_docs.yml")
      }.from('externalDocs' => { 'description' => nil, 'url' => nil }).to('externalDocs' => { 'description' => 'example API', 'url' => 'https://example.com' })
    end
  end

  describe '#save_file_path' do
    it { expect(manager.save_file_path).to eq "#{components_schemas_path}/dummy.yml" }
    it { expect { manager.save_file_path }.to change { FileTest.exists?(components_schemas_path) }.from(false).to(true) }
  end

  describe '#load_data' do
    context 'when file exists' do
      before do
        create_dir('components/schemas')
        create_dummy_components_schemas_file({
          'components' => {
            'schemas' => {
              'Dummy' => {
                'type' => 'object',
                'properties' => {
                  'id' => {
                    'type' => 'integer',
                    'format' => 'int64'
                  }
                }
              }
            }
          }
        }.to_yaml)
      end

      it do
        expect(manager.load_data).to eq 'components' => { 'schemas' => { 'Dummy' => { 'properties' => { 'id' => { 'format' => 'int64', 'type' => 'integer' } }, 'type' => 'object' } } }
      end
    end

    context 'when file do not exists' do
      it { expect(manager.load_data).to be_blank }
    end

    context 'when file ext_name is not support' do
      before do
        manager.instance_variable_set(:@ext_name, :json)
        @ext_name = manager.instance_variable_get(:@ext_name)
      end

      it { expect { manager.load_data }.to raise_error(R2OAS::NoSupportError, "Do not support @ext_name: #{@ext_name}") }
    end
  end

  describe '#descendants_paths' do
    it { expect(manager.descendants_paths).to be_blank }
  end
end
