# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/analyzer'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::Analyzer do
  let(:before_schema_data) { {} }
  let(:after_schema_data) { {} }
  let(:analyzer_options) { {} }
  let(:analyzer) { described_class.new(before_schema_data, after_schema_data, analyzer_options) }

  after do
    delete_swagger_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should generate docs' do
      expect(FileTest.exists?(components_schemas_path)).to eq result
      expect(FileTest.exists?(components_request_bodies_path)).to eq result
      expect(FileTest.exists?(paths_path)).to eq result
      expect(FileTest.exists?(external_docs_path)).to eq result
      expect(FileTest.exists?(info_path)).to eq result
      expect(FileTest.exists?(openapi_path)).to eq result
      expect(FileTest.exists?(servers_path)).to eq result
      expect(FileTest.exists?(tags_path)).to eq result
    end
  end

  describe '#analyze_docs' do
    context 'when type is :existing' do
      context 'when SWAGGER_FILE is blank' do
        let(:analyzer_options) { { type: :existing, existing_schema_file_path: '' } }

        it 'should raise error' do
          expect { analyzer.analyze_docs }.to raise_error(RoutesToSwaggerDocs::NoFileExistsError, "Do not exists file: #{doc_save_file_path}")
        end
      end

      context 'when SWAGGER_FILE is present' do
        before do
          analyzer.analyze_docs
        end

        context 'file type is json' do
          let(:analyzer_options) { { type: :existing, existing_schema_file_path: swagger_file_path(:json) } }

          it_behaves_like 'Generated file verification test', true
        end

        context 'file type is yaml' do
          let(:analyzer_options) { { type: :existing, existing_schema_file_path: swagger_file_path(:yaml) } }

          it_behaves_like 'Generated file verification test', true
        end

        context 'file type is yml' do
          let(:analyzer_options) { { type: :existing, existing_schema_file_path: swagger_file_path(:yml) } }

          it_behaves_like 'Generated file verification test', true
        end
      end
    end

    context 'when type is :edited' do
      let(:before_schema_data) { YAML.load_file editor_file_path(:before) }
      let(:after_schema_data) { YAML.load_file editor_file_path(:after) }
      let(:analyzer_options) { { type: :edited } }
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        create_dot_paths
        generate_docs(generator_options)
        analyzer.analyze_docs
      end

      it_behaves_like 'Generated file verification test', true
      it 'The file obtained by editing exists' do
        expect(FileTest.exists?("#{components_schemas_path}/task/edit/p1/get/200.yml")).to eq true
      end
    end
  end
end
