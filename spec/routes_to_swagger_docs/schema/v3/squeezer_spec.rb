# frozen_string_literal: true

require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/squeezer'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::Squeezer do
  let(:before_schema_data) { YAML.load_file docs_file_path(:before) }
  let(:many_paths_file_paths) { [] }

  let(:squeezer_options) { { many_paths_file_paths: many_paths_file_paths } }
  let(:squeezer) { described_class.new(before_schema_data, squeezer_options) }

  let(:generator_options) { { skip_load_dot_paths: true } }

  before do
    create_dot_paths
    generate_docs(generator_options)
  end

  after do
    delete_swagger_docs
  end

  describe '#squeeze_docs' do
    let(:many_paths_file_paths) { Dir.glob("#{paths_path}/task.yml") }

    before do
      @after_squeeze_data = squeezer.squeeze_docs
    end

    it 'should squeeze tags && paths' do
      expect(@after_squeeze_data['paths']['/tasks']).not_to eq nil
      expect(@after_squeeze_data['paths']['/api/v1/tasks']).to eq nil
      expect(@after_squeeze_data['tags']).to include('description' => 'task description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'task')
      expect(@after_squeeze_data['tags']).not_to include('description' => 'api/v1/task description', 'externalDocs' => { 'description' => 'description', 'url' => 'url' }, 'name' => 'api/v1/task')
    end
  end
end
