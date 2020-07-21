# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/store'

# rubocop:disable Metrics/BlockLength, Layout/LineLength
RSpec.describe R2OAS::Store do
  let(:servers) { "---\nservers:\n- url: http://localhost:3000\n  description: localhost\n" }
  let(:tags) { "---\ntags:\n- name: api/v2/post\n  description: api/v2/post description\n  externalDocs:\n    description: description\n    url: url\n- name: api/v1/task\n  description: api/v1/task description\n  externalDocs:\n    description: description\n    url: url\n- name: user\n  description: user description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/blob\n  description: active_storage/blob description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/representation\n  description: active_storage/representation description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/disk\n  description: active_storage/disk description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/direct_upload\n  description: active_storage/direct_upload description\n  externalDocs:\n    description: description\n    url: url\n" }
  let(:data) do
    {
      'type' => :schema,
      'data' => {
        '9c76ba3fa791db0191ab608c3703b70b89a514ec' => {
          'key' => 'oas_docs/src/servers.yml',
          'value' => Zlib::Deflate.deflate(servers)
        },
        '3f134b36f0ef4bba266a0f4dd60a4f17a0709992' => {
          'key' => 'oas_docs/src/tags.yml',
          'value' => Zlib::Deflate.deflate(tags)
        }
      }
    }
  end

  let(:model) { described_class.new(:schema, data) }

  describe '#add' do
    subject { model.add('oas_docs/src/servers.yml', servers) }
    it { is_expected.not_to be_blank }
  end

  describe '#save' do
    before do
      allow_any_instance_of(R2OAS::Schema::FileManager).to receive(:save).and_return(true)
    end

    it do
      expect { |b| model.save(&b) }.to yield_control
    end
  end

  describe '#dup_slice' do
    let(:keys) { ['9c76ba3fa791db0191ab608c3703b70b89a514ec'] }
    let(:result) do
      {
        'type' => :schema,
        'data' => {
          '9c76ba3fa791db0191ab608c3703b70b89a514ec' => {
            'key' => 'oas_docs/src/servers.yml',
            'value' => Zlib::Deflate.deflate(servers)
          }
        }
      }
    end
    subject { model.dup_slice(*keys) }

    it { is_expected.to be_kind_of(described_class) }
    it { expect(subject.data).to eq result }
    it { is_expected.not_to eq model }
  end

  describe '#checksum?' do
    subject { model.checksum? }

    context 'when success' do
      it { is_expected.to be true }
    end

    context 'when failure' do
      let(:data) do
        {
          'type' => :schema,
          'data' => {
            'faiowhfoiahoiwahfiohaoifhaiofhaoihwfhaoi' => {
              'key' => 'oas_docs/src/servers.yml',
              'value' => Zlib::Deflate.deflate(servers)
            },
            'foiahfoiahfwoihafiohaiofhaiofhaiofhaoihaa' => {
              'key' => 'oas_docs/src/tags.yml',
              'value' => Zlib::Deflate.deflate(tags)
            }
          }
        }
      end

      it { is_expected.to be false }
    end
  end

  describe '#key?' do
    let(:key) { '' }
    subject { model.key?(key) }

    context 'when success' do
      let(:key) { '9c76ba3fa791db0191ab608c3703b70b89a514ec' }
      it { is_expected.to eq true }
    end

    context 'when failure' do
      let(:key) { 'faiowhfoiahoiwahfiohaoifhaiofhaoihwfhaoi' }
      it { is_expected.to eq false }
    end
  end

  describe '#exists?' do
    subject { model.exists? }

    context 'when success' do
      it { is_expected.to eq true }
    end

    context 'when failure' do
      let(:data) do
        {
          'type' => :schema,
          'data' => {}
        }
      end
      it { is_expected.to eq false }
    end
  end

  describe '#diff_from' do
    let(:local_servers) { "---\nservers:\n- url: http://localhost:3008\n  description: localhost\n" }
    let(:local_tags) { "---\ntags:\n- name: api/v2/post\n  description: api/v2/post local description\n  externalDocs:\n    description: description\n    url: url\n- name: api/v1/task\n  description: api/v1/task description\n  externalDocs:\n    description: description\n    url: url\n- name: user\n  description: user description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/blob\n  description: active_storage/blob description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/representation\n  description: active_storage/representation description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/disk\n  description: active_storage/disk description\n  externalDocs:\n    description: description\n    url: url\n- name: active_storage/direct_upload\n  description: active_storage/direct_upload description\n  externalDocs:\n    description: description\n    url: url\n" }
    let(:local_store_data) do
      {
        'type' => :schema,
        'data' => {
          '9c76ba3fa791db0191ab608c3703b70b89a514ec' => {
            'key' => 'oas_docs/src/servers.yml',
            'value' => Zlib::Deflate.deflate(local_servers)
          },
          '3f134b36f0ef4bba266a0f4dd60a4f17a0709992' => {
            'key' => 'oas_docs/src/tags.yml',
            'value' => Zlib::Deflate.deflate(local_tags)
          }
        }
      }
    end
    let(:local_store) { described_class.new(:schema, local_store_data) }

    context 'when block given' do
      it do
        expect { |b| model.diff_from(local_store, &b) }.to yield_control
      end
    end

    context 'when block not given' do
      it do
        expect(model.diff_from(local_store)).to eq 'oas_docs/src/servers.yml' => { 'after' => { 'servers' => [{ 'description' => 'localhost', 'url' => 'http://localhost:3000' }] }, 'before' => { 'servers' => [{ 'description' => 'localhost', 'url' => 'http://localhost:3008' }] } }, 'oas_docs/src/tags.yml' => { 'after' => { 'tags' => [{ 'description' => 'api/v2/post description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'api/v2/post' }, { 'description' => 'api/v1/task description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'api/v1/task' }, { 'description' => 'user description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'user' }, { 'description' => 'active_storage/blob description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/blob' }, { 'description' => 'active_storage/representation description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/representation' }, { 'description' => 'active_storage/disk description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/disk' }, { 'description' => 'active_storage/direct_upload description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/direct_upload' }] }, 'before' => { 'tags' => [{ 'description' => 'api/v2/post local description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'api/v2/post' }, { 'description' => 'api/v1/task description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'api/v1/task' }, { 'description' => 'user description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'user' }, { 'description' => 'active_storage/blob description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/blob' }, { 'description' => 'active_storage/representation description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/representation' }, { 'description' => 'active_storage/disk description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/disk' }, { 'description' => 'active_storage/direct_upload description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'active_storage/direct_upload' }] } }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength, Layout/LineLength
