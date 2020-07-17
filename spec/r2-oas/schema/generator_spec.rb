# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::Generator do
  let(:generator_options) { {} }
  let(:generator) { described_class.new(generator_options) }

  before do
    init
  end

  after do
    delete_oas_docs
  end

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Generator instance' do
        expect(generator.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(R2OAS).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect { generator }.to raise_error(R2OAS::NoImplementError, 'Do not support version: v2')
      end
    end
  end
end
