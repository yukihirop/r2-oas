# frozen_string_literal: true

require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/analyzer/base_analyzer'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::BaseAnalyzer do
  let(:before_schema_data) { {} }
  let(:after_schema_data) { {} }
  let(:analyzer) { described_class.new(before_schema_data, after_schema_data) }

  describe '#analyze_docs' do
    it { expect { analyzer.analyze_docs }.to raise_error(RoutesToSwaggerDocs::NoImplementError, 'Please implement in inherited class.') }
  end

  describe '#generate_from_existing_schema' do
    it { expect { analyzer.generate_from_existing_schema }.to raise_error(RoutesToSwaggerDocs::NoImplementError, 'Please implement in inherited class.') }
  end
end
