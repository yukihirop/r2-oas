# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/cleaner'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::Cleaner do
  let(:cleaner_options) { {} }
  let(:cleaner) { described_class.new(cleaner_options) }

  let(:generator_options) { { skip_load_dot_paths: true } }

  describe '#clean_docs' do
    before do
      create_dot_paths
      generate_docs(generator_options)
      # create dummy components/schemas file
      create_dummy_components_schemas_file
      create_components_securitySchemes_file
      cleaner.clean_docs
    end

    after do
      delete_swagger_docs
    end

    it 'remove unreferenced components files(except securitySchemes files)' do
      expect(FileTest.exists?("#{components_schemas_path}/dummy.yml")).to eq false
      expect(FileTest.exists?("#{components_securitySchemes_path}/my_oauth.yml")).to eq true
    end
  end
end
