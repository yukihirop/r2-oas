require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Schema::Cleaner do
  let(:cleaner_options) { {} }
  let(:cleaner) { described_class.new(cleaner_options) }

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Cleaner instance' do
        expect(cleaner.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(RoutesToSwaggerDocs).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect{ cleaner }.to raise_error(RoutesToSwaggerDocs::NoImplementError, "Do not support version: v2")
      end
    end
  end
end
