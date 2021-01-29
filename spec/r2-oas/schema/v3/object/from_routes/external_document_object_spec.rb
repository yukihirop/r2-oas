# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::ExternalDocumentObject do
  let(:opts) { {} }
  let(:object) { described_class.new(opts) }

  describe '#create_doc' do
    it { expect(object.send(:create_doc)).to eq 'description' => '', 'url' => '' }
  end
end
