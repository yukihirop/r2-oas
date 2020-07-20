# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/openapi_object'

RSpec.describe R2OAS::Schema::V3::FromFiles::OpenapiObject do
  let(:info_doc) { double('InfoObject#to_doc') }
  let(:paths_doc) { double('PathsObject#to_doc') }
  let(:external_docs_doc) { double('ExternalDocumentObject#to_doc') }
  let(:components_doc) { double('ComponentsObject#to_doc') }

  let(:tags_doc) { double('tags') }
  let(:servers_doc) { double('servers') }

  let(:doc) do
    {
      'openapi' => '3.0.0',
      'info' => info_doc,
      'tags' => tags_doc,
      'paths' => paths_doc,
      'externalDocs' => external_docs_doc,
      'servers' => servers_doc,
      'components' => components_doc
    }
  end
  let(:opts) { {} }
  let(:object) { described_class.new(doc, opts) }

  describe '#to_doc' do
    before do
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::BaseObject).to receive(:set_root_doc)
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::BaseObject).to receive(:set_components_name_list)
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::InfoObject).to receive(:to_doc).and_return(info_doc)
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::PathsObject).to receive(:to_doc).and_return(paths_doc)
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::ExternalDocumentObject).to receive(:to_doc).and_return(external_docs_doc)
      allow_any_instance_of(R2OAS::Schema::V3::FromFiles::ComponentsObject).to receive(:to_doc).and_return(components_doc)
    end
    context 'when default' do
      it { expect(object.to_doc['openapi']).to eq '3.0.0' }
      it { expect(object.to_doc['info']).to eq info_doc }
      it { expect(object.to_doc['tags']).to eq tags_doc }
      it { expect(object.to_doc['paths']).to eq paths_doc }
      it { expect(object.to_doc['externalDocs']).to eq external_docs_doc }
      it { expect(object.to_doc['servers']).to eq servers_doc }
      it { expect(object.to_doc['components']).to eq components_doc }
    end

    context 'when use plugins (setup)' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestSetupTransform < ::R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-setup-test'

          setup do
            self.opts = { setup: true }
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            'r2oas-plugin-transform-setup-test'
          ]
        end

        object.to_doc
      end

      it { expect(TestSetupTransform.opts).to eq setup: true }
    end

    context 'when use plugins (teardown)' do
      let(:opts) { { use_plugin: true } }

      before do
        class TestTeardownTransform < ::R2OAS::Plugin::Transform
          self.plugin_name = 'r2oas-plugin-transform-teardown-test'

          teardown do
            self.opts = { teardown: true }
          end
        end

        R2OAS.configure do |config|
          config.plugins = [
            'r2oas-plugin-transform-teardown-test'
          ]
        end

        object.to_doc
      end

      it { expect(TestTeardownTransform.opts).to eq teardown: true }
    end
  end
end
