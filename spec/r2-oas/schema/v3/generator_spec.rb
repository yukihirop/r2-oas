# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/generator'

RSpec.describe R2OAS::Schema::V3::Generator do
  let(:generator_options) { {} }
  let(:generator) { described_class.new(generator_options) }

  before do
    create_dot_paths
  end

  after do
    delete_oas_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should generate docs' do
      expect(FileTest.exists?(components_schemas_path)).to eq result
      expect(FileTest.exists?(components_request_bodies_path)).to eq result
      expect(FileTest.exists?(paths_path)).to eq result
      expect(FileTest.exists?(external_docs_path)).to eq result
      expect(FileTest.exists?(info_path)).to eq result
      expect(FileTest.exists?(openapi_path)).to eq result
      expect(FileTest.exists?(servers_path)).to eq result
      expect(FileTest.exists?(tags_path)).to eq result
    end
  end

  describe '#generate_docs' do
    context 'when skip_load_dot_paths is true' do
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        generator.generate_docs
      end

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists?(doc_save_file_path)).to eq true }
    end
  end

  describe '#oas_doc' do
    context 'when skip_load_dot_paths is true' do
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        generator.generate_docs
      end

      it 'should be present' do
        expect(generator.oas_doc).not_to be_blank
      end
    end
  end
end
