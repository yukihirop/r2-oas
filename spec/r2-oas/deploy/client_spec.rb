# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/deploy/client'

RSpec.describe R2OAS::Deploy::Client do
  let(:client) { described_class.new }

  describe '#deploy' do
    before do
      create_dot_paths
      generate_docs
      build_docs
      client.deploy
    end

    after do
      delete_oas_docs
      delete_deploy_docs
    end

    it do
      expect(FileTest.exists?(deploy_dir_path)).to eq true
      expect(FileTest.exists?("#{deploy_dir_path}/index.html")).to eq true
      expect(FileTest.exists?("#{deploy_dir_path}/dist")).to eq true
    end
  end
end
