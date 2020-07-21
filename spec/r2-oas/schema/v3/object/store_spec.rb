# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/store'
RSpec.describe R2OAS::Schema::V3::Store do
  let(:model) { described_class.new(:schema) }
  let(:schema_object) { double("R2OAS::Schama::V3::Components::SchemaObject('#/components/schemas/Task')") }

  describe '#add' do
    subject { model.add('components/schemas', '#/components/schemas/Task', schema_object) }
    it { is_expected.not_to be_blank }
  end

  describe '#gets' do
    before do
      model.add('components/schemas', '#/components/schemas/Task', schema_object)
    end

    subject { model.gets('components/schemas') }

    it { expect(subject).to include schema_object }
  end
end
