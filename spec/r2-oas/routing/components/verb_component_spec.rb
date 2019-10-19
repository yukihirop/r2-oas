# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/routing/components/verb_component'

RSpec.describe R2OAS::Routing::VerbComponent do
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
