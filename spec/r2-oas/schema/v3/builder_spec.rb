# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/builder'

RSpec.describe R2OAS::Schema::V3::Builder do
  let(:builder_options) { {} }
  let(:builder) { described_class.new(builder_options) }

  before do
    init
    generate_docs
  end

  after do
    delete_oas_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should build docs' do
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

  describe '#build_docs' do
    context 'when skip_load_dot_paths is true' do
      let(:builder_options) { { skip_load_dot_paths: true } }

      before do
        builder.build_docs
      end

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exist?(doc_save_file_path)).to eq true }
    end

    context 'when output is true' do
      let(:builder_options) { { output: true } }

      before do
        builder.build_docs
      end

      it { expect(FileTest.exist?(output_path)).to eq true }
    end
  end

  describe '#oas_doc' do
    context 'when default' do
      before do
        builder.build_docs
      end

      it 'should be present' do
        expect(builder.oas_doc).not_to be_blank
      end
    end

    context 'when skip_load_dot_paths is true' do
      let(:builder_options) { { skip_load_dot_paths: true } }

      before do
        builder.build_docs
      end

      it 'should be present' do
        expect(builder.oas_doc).not_to be_blank
      end
    end
  end

  describe '#pure_oas_doc' do
    context 'when default' do
      before do
        builder.build_docs
      end

      it 'should be present' do
        expect(builder.pure_oas_doc).not_to be_blank
      end
    end

    context 'when skip_load_dot_paths is true' do
      let(:builder_options) { { skip_load_dot_paths: true } }

      before do
        builder.build_docs
      end

      it 'should be present' do
        expect(builder.pure_oas_doc).not_to be_blank
      end
    end
  end
end
