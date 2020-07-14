# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/routing/components/request_component'

RSpec.describe R2OAS::Routing::RequestComponent do
  let(:request) { '' }
  let(:is_route_engine) { false }
  let(:comp) { described_class.new(request, is_route_engine) }

  before do
    R2OAS.configure do |config|
      config.use_schema_namespace = true
    end
  end

  describe '#to_tag_name' do
    context 'when route is not engine' do
      let(:request) { 'api/v1/tasks#show' }
      let(:is_route_engine) { false }

      it { expect(comp.to_tag_name).to eq 'api/v1/task' }
    end

    context 'when route is engine' do
      let(:request) { 'RailsAdmin::Engine' }
      let(:is_route_engine) { true }

      it { expect(comp.to_tag_name).to eq 'rails_admin/engine' }
    end
  end

  describe '#to_schema_name' do
    context 'when route is not engine' do
      let(:request) { 'api/v1/tasks#show' }
      let(:is_route_engine) { false }

      it { expect(comp.to_schema_name).to eq 'Api_V1_Task' }
    end

    context 'when route is engine' do
      let(:request) { 'RailsAdmin::Engine' }
      let(:is_route_engine) { true }

      it { expect(comp.to_schema_name).to eq 'RailsAdmin_Engine' }
    end
  end

  describe '#to_format_name' do
    context 'when format exists' do
      let(:request) { 'tasks#index {:format=>:json}' }
      let(:is_route_engine) { false }

      it { expect(comp.to_format_name).to eq 'json' }
    end

    context 'when format do not exists' do
      let(:request) { 'RailsAdmin::Engine' }
      let(:is_route_engine) { true }

      it { expect(comp.to_format_name).to eq '' }
    end
  end
end
