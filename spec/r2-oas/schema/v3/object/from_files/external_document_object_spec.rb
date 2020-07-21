# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/external_document_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::ExternalDocumentObject do
  let(:opts) { {} }
  let(:object) { described_class.new({}, opts) }

  describe '#to_doc' do
    context 'when use plugins' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestExternalDocumentTransform < R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-test-external-document'

          external_document do |doc|
            if opts[:merged]
              doc.merge!(
                'plugin_key' => 'plugin_value'
              )
            end
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            ['r2oas-plugin-transform-test-external-document', { merged: true }]
          ]
        end
      end

      it { expect(object.to_doc['plugin_key']).to eq 'plugin_value' }
    end
  end
end
