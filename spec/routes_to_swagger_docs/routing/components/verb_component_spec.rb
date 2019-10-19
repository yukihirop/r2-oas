# frozen_string_literal: true

require 'spec_helper'
require 'routes_to_swagger_docs/routing/components/verb_component'

RSpec.describe RoutesToSwaggerDocs::Routing::VerbComponent do
  let(:verb) { '' }
  let(:comp) { described_class.new(verb) }

  describe '#verbs' do
    context 'when verb is blank' do
      let(:verb) { '' }
      it { expect(comp.verbs).to include 'get' }
    end

    context 'when verb is unit' do
      let(:verb) { 'GET' }
      it { expect(comp.verbs).to include('get') }
    end

    context 'when verb is composite' do
      let(:verb) { 'GET|POST' }
      it { expect(comp.verbs).to include('get', 'post') }
    end
  end
end
