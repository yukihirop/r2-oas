# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_routes/server_object'

RSpec.describe R2OAS::Schema::V3::ServerObject do
  let(:object) { described_class.new }

  describe '#to_doc' do
    before do
      R2OAS.configure do |config|
        config.server.data = [
          {
            url: 'http://localhost:3000',
            description: 'main'
          },
          {
            url: 'http://localhost:3001',
            description: 'sub'
          }
        ]
      end
    end

    it { expect(object.to_doc[0]).to eq 'description' => 'main', 'url' => 'http://localhost:3000' }
    it { expect(object.to_doc[1]).to eq 'description' => 'sub', 'url' => 'http://localhost:3001' }
  end
end
