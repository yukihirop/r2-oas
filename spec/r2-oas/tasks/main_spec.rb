# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'main_rake' do
  let(:task_name) { '' }
  let(:task) { Rake.application[task_name] }

  after do
    delete_oas_docs
  end

  subject do
    task.invoke
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

  describe 'routes:oas:docs' do
    let(:task_name) { 'routes:oas:docs' }

    context 'when default' do
      before do
        subject
      end

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists?(doc_save_file_path)).to eq false }
    end

    context 'when oas_docs exists already' do
      before do
        create_dot_paths
        generate_docs
        delete_cache_docs
      end

      it 'should occur error' do
        expect { subject }.to raise_error(R2OAS::NoFileExistsError)
      end

      context 'when specify CACHE_DOCS' do
        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with('CACHE_DOCS', 'false').and_return('true')
        end

        it 'should do not occur error' do
          expect { subject }.not_to raise_error(R2OAS::NoFileExistsError)
        end
        it do
          subject
          expect(FileTest.exists?(relative_cache_docs_path)).to eq true
        end
      end
    end
  end

  describe 'routes:oas:analyze' do
    let(:task_name) { 'routes:oas:analyze' }
    let(:ext_name) { '' }

    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with('OAS_FILE', '').and_return(swagger_file_path(ext_name))
      subject
    end

    context 'when ext_name is :json' do
      let(:ext_name) { :json }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists?(doc_save_file_path)).to eq true }
    end

    context 'when ext_name is :yml' do
      let(:ext_name) { :yml }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists?(doc_save_file_path)).to eq true }
    end

    context 'when ext_name is :yaml' do
      let(:ext_name) { :yml }

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists?(doc_save_file_path)).to eq true }
    end
  end

  describe 'routes:oas:dist' do
    let(:task_name) { 'routes:oas:dist' }

    before do
      generate_docs
      build_docs
    end

    it { expect(FileTest.exists?(doc_save_file_path)).to eq true }
  end

  describe 'routes:oas:clean' do
    let(:task_name) { 'routes:oas:clean' }

    before do
      create_dot_paths
      generate_docs
      create_dummy_components_schemas_file
      create_dummy_components_request_bodies_file
      create_components_securitySchemes_file
      subject
    end

    it do
      expect(FileTest.exists?("#{components_schemas_path}/dummy.yml")).to eq false
      expect(FileTest.exists?("#{components_request_bodies_path}/dummy.yml")).to eq false
      expect(FileTest.exists?("#{components_securitySchemes_path}/my_oauth.yml")).to eq true
    end
  end
end
