require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Schema::Generator do
  let(:generator_options) { {} }
  let(:generator) { described_class.new(generator_options) }

  before do
    create_dot_paths
  end

  after do
    delete_swagger_docs
  end

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Generator instance' do
        expect(generator.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(RoutesToSwaggerDocs).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect{ generator }.to raise_error(RoutesToSwaggerDocs::NoImplementError, "Do not support version: v2")
      end
    end
  end
end