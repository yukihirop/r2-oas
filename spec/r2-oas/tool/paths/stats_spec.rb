# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/tool/paths/stats'

RSpec.describe R2OAS::Tool::Paths::Stats do
  let(:stats) { described_class.new }

  before do
    create_dot_paths
    generate_docs
  end

  after do
    delete_swagger_docs
  end

  describe '#print' do
    it 'should show paths list' do
      expect(stats.print).to eq nil
    end
  end
end
