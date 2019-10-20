# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'tool_rake' do
  let(:task_name) { '' }
  let(:task) { Rake.application[task_name] }

  after do
    delete_oas_docs
    delete_deploy_docs
  end

  describe 'routes:oas:deploy' do
    let(:task_name) { 'routes:oas:deploy' }

    before do
      create_dot_paths
      generate_docs
      task.invoke
    end

    it do
      expect(FileTest.exists?("#{deploy_dir_path}")).to eq true
      expect(FileTest.exists?("#{deploy_dir_path}/#{doc_save_file_name}")).to eq true
    end
  end

  describe 'routes:oas:paths_ls' do
    let(:task_name) { 'routes:oas:paths_ls' }

    before do
      create_dot_paths
      generate_docs
    end

    it { expect { task.invoke }.not_to raise_error }
  end

  describe 'routes:oas:paths_stats' do
    let(:task_name) { 'routes:oas:paths_stats' }

    before do
      create_dot_paths
      generate_docs
    end

    it { expect { task.invoke }.not_to raise_error }
  end
end
