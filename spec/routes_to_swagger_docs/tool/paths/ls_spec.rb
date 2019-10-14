require 'spec_helper'
require 'routes_to_swagger_docs/tool/paths/ls'

RSpec.describe RoutesToSwaggerDocs::Tool::Paths::Ls do
  let(:ls) { described_class.new }

  before do
    create_dot_paths
    generate_docs
  end

  after do
    delete_swagger_docs
  end

  describe '#print' do
    it 'should show paths list' do
      expect(ls.print).to include(
        File.expand_path("#{paths_path}/task.yml"),
        File.expand_path("#{paths_path}/api/v1/task.yml")
      )
    end
  end
end
