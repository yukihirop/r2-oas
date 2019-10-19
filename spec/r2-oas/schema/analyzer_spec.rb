# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::Analyzer do
  let(:before_schema_data) { {} }
  let(:after_schema_data) { {} }
  let(:analyzer_options) { {} }
  let(:analyzer) { described_class.new(before_schema_data, after_schema_data, analyzer_options) }

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Analyzer instance' do
        expect(analyzer.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(R2OAS).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect { analyzer }.to raise_error(R2OAS::NoImplementError, 'Do not support version: v2')
      end
    end
  end
end
