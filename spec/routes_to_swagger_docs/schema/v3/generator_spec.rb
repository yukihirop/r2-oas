require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/generator'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::Generator do
  let(:generator_options) { {} }
  let(:generator) { described_class.new(generator_options) }

  before do
    create_dot_paths
  end

  after do
    delete_swagger_docs
  end

  shared_examples_for 'Generated file verification test' do |result|
    it 'should generate docs' do
      expect(FileTest.exists? components_schemas_path).to eq result
      expect(FileTest.exists? components_request_bodies_path).to eq result
      expect(FileTest.exists? paths_path).to eq result
      expect(FileTest.exists? external_docs_path).to eq result
      expect(FileTest.exists? info_path).to eq result
      expect(FileTest.exists? openapi_path).to eq result
      expect(FileTest.exists? servers_path).to eq result
      expect(FileTest.exists? tags_path).to eq result
    end
  end

  describe '#generate_docs' do
    context 'when skip_load_dot_paths is true' do
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        generator.generate_docs
      end

      it_behaves_like 'Generated file verification test', true
      it { expect(FileTest.exists? doc_save_file_path).to eq true }
    end

    context 'when skip_generate_docs is true' do
      let(:generator_options) { { skip_generate_docs: true } }

      context 'when file do not exists at doc_save_file_path' do
        it { expect(generator.generate_docs).to eq true }
      end

      context 'when file exists at doc_save_file_path' do
        before do
          create_save_doc
        end

        it_behaves_like 'Generated file verification test', false
      end
    end
  end

  describe '#swagger_doc' do
    context 'when skip_load_dot_paths is true' do
      let(:generator_options) { { skip_load_dot_paths: true } }

      before do
        generator.generate_docs
      end

      it 'should be present' do
        expect(generator.swagger_doc).not_to be_blank
      end
    end

    context 'when skip_generate_docs is true' do
      let(:generator_options) { { skip_generate_docs: true } }

      context 'when file exists at doc_save_file_path' do
        before do
          # Strike the docs command in advance
          generate_docs
          generator.generate_docs
          @swagger_doc = generator.swagger_doc
        end

        it 'should be present' do
          expect(generator.swagger_doc).not_to be_blank
        end

        context 'when PATHS_FILE is present' do
          let(:unit_paths_file_path) { "#{paths_path}/task.yml" }
          let(:generator_options) { {skip_generate_docs: true, unit_paths_file_path: unit_paths_file_path} }

          it 'should squeeze paths' do
            expect(@swagger_doc['paths']['/tasks']).not_to be_blank
            expect(@swagger_doc['paths']['/api/v1/tasks']).to be_blank
          end
        end
      end
    end
  end
end
