# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Routing::PathComponent do
  let(:path) { '' }
  let(:comp) { described_class.new(path) }

  describe '#to_s' do
    let(:path) { '/api/v1/tasks/{id}' }
    it { expect(comp.to_s).to eq '/api/v1/tasks/{id}' }
  end

  describe '#symbol_to_brace' do
    let(:path) { '/api/v1/tasks/:id' }
    it { expect(comp.symbol_to_brace).to eq '/api/v1/tasks/{id}' }
  end

  describe '#path_parameters_data' do
    context 'when path parameters exists' do
      let(:path) { '/api/v1/tasks/:task_id/discriptions/:type' }
      it do
        expect(comp.path_parameters_data[:task_id]).to eq type: 'integer'
        expect(comp.path_parameters_data[:type]).to eq type: 'string'
      end
    end

    context 'when path parameters do not exists' do
      let(:path) { '/api/v1/tasks' }
      it do
        expect(comp.path_parameters_data).to be_blank
      end
    end
  end

  describe '#path_excluded_path_parameters' do
    let(:path) { '/api/v1/tasks/:task_id/descriptions/:type' }
    it { expect(comp.path_excluded_path_parameters).to eq 'api/v1/tasks/descriptions' }
  end

  describe '#exist_path_parameters?' do
    context 'when path parameters exists' do
      let(:path) { '/api/v1/tasks/:task_id/descriptions/:type' }
      it { expect(comp.exist_path_parameters?).to eq true }
    end

    context 'when path parameters do not exists' do
      let(:path) { '/api/v1/tasks' }
      it { expect(comp.exist_path_parameters?).to eq false }
    end
  end

  describe '#path_parameters' do
    context 'when path parameters exists' do
      let(:path) { '/api/v1/tasks/:task_id/descriptions/:type' }
      it { expect(comp.path_parameters).to include('task_id', 'type') }
    end

    context 'when path parameters do not exists' do
      let(:path) { '/api/v1/tasks' }
      it { expect(comp.path_parameters).to be_blank }
    end
  end
end
