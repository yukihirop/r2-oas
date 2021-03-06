# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::Squeezer do
  let(:before_schema_data) { {} }
  let(:many_paths_file_paths) { [] }

  let(:squeezer_options) { { many_paths_file_paths: many_paths_file_paths } }
  let(:squeezer) { described_class.new(before_schema_data, squeezer_options) }

  let(:generator_options) { { skip_load_dot_paths: true } }
  let(:generator) { R2OAS::Schema::Generator.new(generator_options) }

  describe '.initialize' do
    context 'when version is :v3' do
      it 'should return Squeezer instance' do
        expect(squeezer.class).to eq described_class
      end
    end

    context 'when version is :v2 (do not support)' do
      before do
        allow(R2OAS).to receive(:version).and_return(:v2)
      end

      it 'should raise error' do
        expect { squeezer }.to raise_error(R2OAS::NoImplementError, 'Do not support version: v2')
      end
    end
  end
end
