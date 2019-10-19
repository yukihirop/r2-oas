# frozen_string_literal: true

require 'spec_helper'

RSpec.describe R2OAS::Schema::V3::ExternalDocumentObject do
  let(:object) { R2OAS.use_object_classes[:external_document_object].new }

  after do
    reset_config
  end

  describe '#to_doc' do
    context 'when use before_create && after_create' do
      before do
        class TestExternalDocumentObject < R2OAS::Schema::V3::ExternalDocumentObject
          before_create do |doc|
            doc.merge!(
              'before_key' => 'before_value'
            )
          end

          after_create do |doc|
            doc.merge!(
              'after_key' => 'after_value'
            )
          end
        end

        R2OAS.configure do |config|
          config.use_object_classes.merge!(
            external_document_object: TestExternalDocumentObject
          )
        end
      end

      it { expect(object.to_doc['before_key']).to eq 'before_value' }
      it { expect(object.to_doc['after_key']).to eq 'after_value' }
    end
  end

  describe '#create_doc' do
    it { expect(object.create_doc).to eq 'description' => '', 'url' => '' }
  end
end
