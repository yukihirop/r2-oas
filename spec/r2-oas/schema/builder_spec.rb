# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::Builder do
  let(:builder_options) { {} }
  let(:builder) { described_class.new(builder_options) }

  before do
    create_dot_paths
    generate_docs
  end

  after do
    delete_oas_docs
    reset_config
  end

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Builder instance' do
        expect(builder.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(R2OAS).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect { builder }.to raise_error(R2OAS::NoImplementError, 'Do not support version: v2')
      end
    end
  end
end
