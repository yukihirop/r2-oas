require 'spec_helper'

RSpec.describe 'tool_rake' do
  let(:task_name) { '' }
  let(:task) { Rake.application[task_name] }

  after do
    delete_swagger_docs
    delete_docs_for_deploy
  end

  describe 'routes:swagger:deploy' do
    let(:task_name) { 'routes:swagger:deploy' }

    before do
      create_dot_paths
      generate_docs
      task.invoke
    end

    it do
      expect(FileTest.exists?("#{Rails.root}/docs")).to eq true
      expect(FileTest.exists?("#{Rails.root}/docs/#{doc_save_file_name}")).to eq true
    end
  end

  describe 'routes:swagger:paths_ls' do
    let(:task_name) { 'routes:swagger:paths_ls' }

    before do
      create_dot_paths
      generate_docs
    end

    it { expect{ task.invoke }.not_to raise_error }
  end

  describe 'routes:swagger:paths_stats' do
    let(:task_name) { 'routes:swagger:paths_stats' }

    before do
      create_dot_paths
      generate_docs
    end

    it { expect{ task.invoke }.not_to raise_error }
  end
end
