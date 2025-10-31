# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/generator'

RSpec.describe R2OAS::Schema::V3::Generator do
  let(:generator_options) { {} }
  let(:generator) { described_class.new(generator_options) }

  before do
    init
  end

  after do
    delete_oas_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should generate docs' do
      expect(FileTest.exist?(components_schemas_path)).to eq result
      expect(FileTest.exist?(components_request_bodies_path)).to eq result
      expect(FileTest.exist?(paths_path)).to eq result
      expect(FileTest.exist?(external_docs_path)).to eq result
      expect(FileTest.exist?(info_path)).to eq result
      expect(FileTest.exist?(openapi_path)).to eq result
      expect(FileTest.exist?(servers_path)).to eq result
      expect(FileTest.exist?(tags_path)).to eq result
    end
  end

  describe '#generate_docs' do
    context 'when skip_load_dot_paths is true' do
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        generator.generate_docs
      end

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exist?(doc_save_file_path)).to eq false }
    end
  end
end
