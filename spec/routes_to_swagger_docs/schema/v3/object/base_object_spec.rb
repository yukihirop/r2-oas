# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::BaseObject do
  let(:object) { described_class.new }
  let(:swagger) { object.send(:swagger) }
  let(:use_object_classes) { object.instance_variable_get(:@use_object_classes) }
  let(:http_statuses_when_http_method) { object.send(:http_statuses_when_http_method) }
  let(:tool_paths_stats) { object.send(:tool).paths_stats }

  after do
    reset_config
  end

  describe '.initialize' do
    context 'when default' do
      it { expect(object.send(:version)).to eq :v3 }
      it { expect(object.send(:root_dir_path)).to eq Rails.root.join('swagger_docs').to_s }
      it { expect(object.send(:schema_save_dir_name)).to eq 'src' }
      it { expect(object.send(:doc_save_file_name)).to eq 'swagger_doc.yml' }
      it { expect(object.send(:force_update_schema)).to eq false }
      it { expect(object.send(:use_tag_namespace)).to eq true }
      it { expect(object.send(:use_schema_namespace)).to eq false }
      it { expect(object.send(:interval_to_save_edited_tmp_schema)).to eq 15 }
      it { expect(object.send(:server).data).to include(description: 'localhost', url: 'http://localhost:3000') }
      it { expect(object.send(:namespace_type)).to eq :underbar }
      it { expect(swagger.ui.image).to eq 'swaggerapi/swagger-ui' }
      it { expect(swagger.ui.port).to eq '8080' }
      it { expect(swagger.ui.exposed_port).to eq '8080/tcp' }
      it { expect(swagger.ui.volume).to eq '/app/swagger.json' }
      it { expect(swagger.editor.image).to eq 'swaggerapi/swagger-editor' }
      it { expect(swagger.editor.port).to eq '81' }
      it { expect(swagger.editor.exposed_port).to eq '8080/tcp' }
      it { expect(use_object_classes[:info_object]).to eq RoutesToSwaggerDocs::Schema::V3::InfoObject }
      it { expect(use_object_classes[:paths_object]).to eq RoutesToSwaggerDocs::Schema::V3::PathsObject }
      it { expect(use_object_classes[:path_item_object]).to eq RoutesToSwaggerDocs::Schema::V3::PathItemObject }
      it { expect(use_object_classes[:external_document_object]).to eq RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject }
      it { expect(use_object_classes[:components_object]).to eq RoutesToSwaggerDocs::Schema::V3::ComponentsObject }
      it { expect(use_object_classes[:components_schema_object]).to eq RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject }
      it { expect(use_object_classes[:components_request_body_object]).to eq RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject }
      it { expect(http_statuses_when_http_method[:get]).to eq default: %w[200 422], path_parameter: %w[200 404 422] }
      it { expect(http_statuses_when_http_method[:post]).to eq default: %w[201 422], path_parameter: %w[201 404 422] }
      it { expect(http_statuses_when_http_method[:patch]).to eq default: %w[204 422], path_parameter: %w[204 404 422] }
      it { expect(http_statuses_when_http_method[:put]).to eq default: %w[204 422], path_parameter: %w[204 404 422] }
      it { expect(http_statuses_when_http_method[:delete]).to eq default: %w[200 422], path_parameter: %w[200 404 422] }
      it { expect(object.send(:http_methods_when_generate_request_body)).to include('post', 'patch', 'put') }
      it { expect(tool_paths_stats.month_to_turn_to_warning_color).to eq 3 }
      it { expect(tool_paths_stats.warning_color).to eq :red }
      it { expect(tool_paths_stats.table_title_color).to eq :yellow }
      it { expect(tool_paths_stats.heading_color).to eq :yellow }
      it { expect(tool_paths_stats.highlight_color).to eq :magenta }
    end

    context 'when override settings' do
      let(:info_object_class) { double('TestInfoObjectClass') }

      before do
        RoutesToSwaggerDocs.configure do |config|
          config.namespace_type = :dot
          config.doc_save_file_name = 'apidoc.yml'
          config.use_object_classes.merge!(
            info_object: info_object_class
          )
        end
      end

      it { expect(object.send(:namespace_type)).to eq :dot }
      it { expect(object.send(:doc_save_file_name)).to eq 'apidoc.yml' }
      it { expect(use_object_classes[:info_object]).to eq info_object_class }
    end
  end

  describe '#info_object_class' do
    it { expect(object.info_object_class).to eq RoutesToSwaggerDocs::Schema::V3::InfoObject }
  end

  describe '#paths_object_class' do
    it { expect(object.paths_object_class).to eq RoutesToSwaggerDocs::Schema::V3::PathsObject }
  end

  describe '#path_item_object_class' do
    it { expect(object.path_item_object_class).to eq RoutesToSwaggerDocs::Schema::V3::PathItemObject }
  end

  describe '#external_document_object_class' do
    it { expect(object.external_document_object_class).to eq RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject }
  end

  describe '#components_object_class' do
    it { expect(object.components_object_class).to eq RoutesToSwaggerDocs::Schema::V3::ComponentsObject }
  end

  describe '#components_schema_object_class' do
    it { expect(object.components_schema_object_class).to eq RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject }
  end

  describe '#components_request_body_object_class' do
    it { expect(object.components_request_body_object_class).to eq RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject }
  end
end
