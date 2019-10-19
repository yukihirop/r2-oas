# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Configuration::PathsConfig do
  let(:config) { described_class.new(root_dir_path, schema_save_dir_name) }

  before do
    prepare_standard_files
  end

  after do
    delete_swagger_docs
  end

  describe '#abs_paths_path' do
    it { expect(config.abs_paths_path).to eq "#{root_dir_path}/.paths" }
  end

  describe '#all_load_paths?' do
    before do
      create_dot_paths
    end

    context 'when default' do
      it { expect(config.all_load_paths?).to eq false }
    end

    context 'when after load paths files' do
      context 'when .paths is blank' do
        before { config.many_paths_file_paths }
        it { expect(config.all_load_paths?).to eq false }
      end

      context 'when .paths is not blank' do
        before do
          File.write(config.abs_paths_path, 'api/v1/user.yml')
          config.many_paths_file_paths
        end

        it { expect(config.all_load_paths?).to eq true }
      end
    end
  end

  describe '#many_paths_file_paths' do
    before do
      create_dot_paths
    end

    context 'when .paths is blank' do
      it { expect(config.many_paths_file_paths).to be_blank }
    end

    context 'when .paths is not blank' do
      let(:paths_content) do
        <<~EOF
          api/v1/user.yml
          api/v1/task.yml
          api/v1/task.yml
          # comment
        EOF
      end

      before do
        File.write(config.abs_paths_path, paths_content)
      end

      it do
        expect(config.many_paths_file_paths).to include(
          "#{paths_path}/api/v1/user.yml",
          "#{paths_path}/api/v1/task.yml"
        )
      end
    end
  end

  describe '#many_components_file_paths' do
    before do
      create_dot_paths
    end

    context 'many_paths_file_paths is blank' do
      before do
        allow_any_instance_of(described_class).to receive(:many_paths_file_paths).and_return([])
      end

      it { expect(config.many_components_file_paths).to be_blank }
    end

    context 'many_paths_file_paths is not blank' do
      before do
        allow_any_instance_of(described_class).to receive(:many_paths_file_paths).and_return(
          [
            "#{paths_path}/api/v1/user.yml",
            "#{paths_path}/api/v1/task.yml"
          ]
        )
      end

      it do
        expect(config.many_components_file_paths).to include(
          "#{components_schemas_path}/api/v1/user.yml",
          "#{components_schemas_path}/api/v1/task.yml",
          "#{components_schemas_path}/api/v1/task/rb.yml",
          "#{components_request_bodies_path}/api/v1/task/rb.yml"
        )
      end
    end
  end

  describe '#create_dot_paths' do
    it { expect { config.create_dot_paths }.to change { FileTest.exists?("#{root_dir_path}/.paths") }.from(false).to(true) }
  end
end
