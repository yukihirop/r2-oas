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

  describe 'routes:oas:init' do
    let(:task_name) { 'routes:oas:init' }

    before do
      subject
    end

    it do
      expect(FileTest.exists?(plugins_path)).to eq true
      expect(FileTest.exists?("#{plugins_path}/helpers")).to eq true
      expect(FileTest.exists?(tasks_path)).to eq true
      expect(FileTest.exists?(dot_paths_path)).to eq true
      expect(FileTest.exists?("#{plugins_path}/.gitkeep")).to eq true
      expect(FileTest.exists?("#{plugins_path}/helpers/.gitkeep")).to eq true
      expect(FileTest.exists?("#{tasks_path}/.gitkeep")).to eq true
      expect(FileTest.exists?("#{tasks_path}/helpers/.gitkeep")).to eq true
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
        init
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
          expect { subject }.not_to raise_error
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

  describe 'routes:oas:build' do
    let(:task_name) { 'routes:oas:build' }

    before do
      generate_docs
      subject
    end

    it { expect(FileTest.exists?(doc_save_file_path)).to eq false }
    it { expect(FileTest.exists?(output_path)).to eq true }
  end

  describe 'routes:oas:clean' do
    let(:task_name) { 'routes:oas:clean' }

    before do
      init
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

  describe 'routes:oas:deploy' do
    let(:task_name) { 'routes:oas:deploy' }

    before do
      init
      generate_docs
      task.invoke
    end

    after do
      delete_deploy_docs
    end

    it do
      expect(FileTest.exists?(deploy_dir_path.to_s)).to eq true
      expect(FileTest.exists?("#{deploy_dir_path}/#{doc_save_file_name}")).to eq true
      expect(FileTest.exists?(output_path)).to eq true
    end
  end
end
