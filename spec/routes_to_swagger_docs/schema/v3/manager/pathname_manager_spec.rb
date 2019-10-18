require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::PathnameManager do
  let(:path) { '' }
  let(:path_type) { :ref }
  let(:manager) { described_class.new(path, path_type) }

  describe '#object_type' do
    subject { manager.object_type }

    context 'when schemas' do
      let(:path) { '#/components/schemas/Task' }
      it { is_expected.to eq 'schemas' }
    end

    context 'when requestBodies' do
      let(:path) { '#/components/requestBodies/Task' }
      it { is_expected.to eq 'requestBodies' }
    end

    context 'when securitySchemes' do
      let(:path) { '#/components/securitySchemes/Task' }
      it { is_expected.to eq 'securitySchemes' }
    end

    context 'when parameters' do
      let(:path) { '#/components/parameters/Task' }
      it { is_expected.to eq 'parameters' }
    end

    context 'when responses' do
      let(:path) { '#/components/responses/Task' }
      it { is_expected.to eq 'responses' }
    end

    context 'when examples' do
      let(:path) { '#/components/examples/Task' }
      it { is_expected.to eq 'examples' }
    end

    context 'when headers' do
      let(:path) { '#/components/headers/Task' }
      it { is_expected.to eq 'headers' }
    end

    context 'when links' do
      let(:path) { '#/components/links/Task' }
      it { is_expected.to eq 'links' }
    end

    context 'when callbacks' do
      let(:path) { '#/components/callbacks/Task' }
      it { is_expected.to eq 'callbacks' }
    end
  end

  describe '#relative_save_file_path' do
    subject { manager.relative_save_file_path }

    context 'when object_type is support components objects' do
      context 'when path_type is :ref' do
        let(:path) { '#/components/schemas/Task' }
        let(:path_type) { :ref }

        it { is_expected.to eq "#{src_path}/components/schemas/task.yml" }
      end

      context 'when path_type is :relative' do
        let(:path) { 'components/schemas/Task' }
        let(:path_type) { :relative }

        it { is_expected.to eq "#{src_path}/components/schemas/task.yml" }
      end
    end

    context 'when object_type is not support components objects' do
      context 'when path_type is :relative' do
        let(:path) { 'paths/api/v1/task' }
        let(:path_type) { :relative }

        it { is_expected.to eq "#{paths_path}/api/v1/task.yml" }
      end

      context 'when path_type is :full' do
        let(:path) { "#{src_path}/paths/api/v1/task" }
        let(:path_type) { :full }

        it { is_expected.to eq path }
      end

      context 'when path_type is :invalid' do
        let(:path) { 'paths/api/v1/task' }
        let(:path_type) { :invalid }

        it { expect{ subject }.to raise_error(RoutesToSwaggerDocs::NoSupportError, 'Do not support path_type: invalid') }
      end
    end
  end
end
