require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/manager/diff/base_array_diff_manager'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::BaseArrayDiffManager do
  let(:before_schema_data) do
    {
      "base" => [
        {
          "description" => "first",
          "url" => "http://first.com"
        },
        {
          "description" => "second",
          "url" => "http://second.com"
        }
      ]
    }
  end
  let(:after_schema_data) do
    {
      "base" => [
        {
          "description" => "first hoge",
          "url" => "http://first_hoge.com"
        },
        {
          "description" => "second",
          "url" => "http://second.com"
        }
      ]
    }
  end
  let(:manager) { described_class.new(before_schema_data, after_schema_data) }
  
  describe '#process_by_using_diff_data' do
    context 'when block is not given' do
      it { expect(manager.process_by_using_diff_data).to be_nil }
    end

    context 'when block is given' do
      it do
        expect(manager.process_by_using_diff_data { |result| result }).to eq "base" => [{"description"=>"second", "url"=>"http://second.com"}, {"description"=>"second", "url"=>"http://second.com"}]
      end
    end
  end

  describe '#after_target_data' do
    it { expect(manager.after_target_data).to eq "base" => [{"description"=>"first hoge", "url"=>"http://first_hoge.com"}, {"description"=>"second", "url"=>"http://second.com"}] }
  end
end
