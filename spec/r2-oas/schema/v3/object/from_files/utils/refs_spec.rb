# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/schema/v3/object/from_files/utils/refs'

RSpec.describe R2OAS::Schema::V3::FromFiles::PathRef do
  let(:data) { { path: '/api/v1/tasks/{id}' } }
  let(:ref) { described_class.new(data) }

  describe 'accessors' do
    subject { ref }

    it do
      expect(subject.type).to eq :path_item
      expect(subject.path).to eq '/api/v1/tasks/{id}'
      expect(subject[:type]).to eq :path_item
      expect(subject[:path]).to eq '/api/v1/tasks/{id}'
    end

    context 'when error occurs' do
      it do
        expect { subject.type = :hoge }.to raise_error(NoMethodError)
        expect { subject.path = :hoge }.to raise_error(NoMethodError)
        expect { subject[:type] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
        expect { subject[:path] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      end
    end
  end

  describe '#parent' do
    subject { ref }
    it { expect(ref.parent).to be_nil }
  end
end

RSpec.shared_examples 'test accessors when components schema/request_body ref' do |opts|
  opts ||= {}

  context 'when default' do
    it do
      expect(subject.type).to eq data[:type]
      expect(subject.path).to eq data[:path]
      expect(subject.parent_schema_name).to eq data[:parent_schema_name]
      expect(subject.depth).to eq data[:depth]
      expect(subject.tag_name).to eq data[:tag_name]
      expect(subject.verb).to eq data[:verb]
      expect(subject.http_status).to eq data[:http_status] if opts[:http_status]
      expect(subject.from).to eq data[:from]
      expect(subject.schema_name).to eq data[:schema_name]
      expect(subject[:type]).to eq data[:type]
      expect(subject[:path]).to eq data[:path]
      expect(subject[:parent_schema_name]).to eq data[:parent_schema_name]
      expect(subject[:depth]).to eq 0
      expect(subject[:tag_name]).to eq data[:tag_name]
      expect(subject[:verb]).to eq data[:verb]
      expect(subject[:http_status]).to eq data[:http_status] if opts[:http_status]
      expect(subject[:from]).to eq data[:from]
      expect(subject[:schema_name]).to eq data[:schema_name]
    end
  end

  context 'when error occurs' do
    it do
      expect { subject.type = :hoge }.to raise_error(NoMethodError)
      expect { subject.path = :hoge }.to raise_error(NoMethodError)
      expect { subject.parent_schema_name = :hoge }.to raise_error(NoMethodError)
      expect { subject.depth = 1 }.to raise_error(NoMethodError)
      expect { subject.tag_name = :hoge }.to raise_error(NoMethodError)
      expect { subject.verb = :hoge }.to raise_error(NoMethodError)
      expect { subject.http_status = '404' }.to raise_error(NoMethodError)
      expect { subject.from = :path_item }.to raise_error(NoMethodError)
      expect { subject[:type] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:path] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:parent_schema_name] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:depth] = 1 }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:tag_name] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:verb] = :hoge }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:http_status] = '404' }.to raise_error(R2OAS::RefInvalidAssignment)
      expect { subject[:from] = :path_item }.to raise_error(R2OAS::RefInvalidAssignment)
    end
  end

  context 'when error not occurs' do
    it do
      expect { subject.schema_name = 'API_V1_Task_200_GET' }.not_to raise_error
      expect { subject[:schema_name] = 'API_V1_Task_200_GET' }.not_to raise_error
    end
  end
end

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::SchemaRef do
  context 'when have not parent' do
    let(:data) do
      {
        type: :schema,
        path: '/api/v1/tasks',
        parent_schema_name: nil,
        depth: 0,
        tag_name: 'api/v1/tasks',
        verb: 'get',
        http_status: '200',
        from: :path_item,
        schema_name: 'api.v1.Task_200_GET'
      }
    end
    let(:ref) { described_class.new(data) }

    subject { ref }

    describe 'accessors' do
      it_behaves_like 'test accessors when components schema/request_body ref', { http_status: true }
    end

    describe '#parent' do
      it { expect(subject.parent).to be_nil }
    end
  end

  context 'when have parent' do
    let(:parent_data) do
      {
        type: :schema,
        path: '/api/v1/tasks',
        parent_schema_name: nil,
        depth: 0,
        tag_name: 'api/v1/tasks',
        verb: 'get',
        http_status: '200',
        from: :path_item,
        schema_name: 'api.v1.Task_200_GET'
      }
    end

    let(:data) { described_class.new(parent_data) }
    let(:ref) { described_class.new(data) }

    subject { ref }

    describe 'accessors' do
      it_behaves_like 'test accessors when components schema/request_body ref', { http_status: true }
    end

    describe '#parent' do
      it { expect(subject.parent).to eq data }
    end
  end
end

RSpec.describe R2OAS::Schema::V3::FromFiles::Components::RequestBodyRef do
  context 'when have not parent' do
    let(:data) do
      {
        type: :request_body,
        path: '/api/v1/tasks',
        parent_schema_name: nil,
        depth: 0,
        tag_name: 'api/v1/tasks/{id}',
        verb: 'patch',
        http_status: '200',
        from: :path_item,
        schema_name: 'api.v1.Task_200_GET'
      }
    end
    let(:ref) { described_class.new(data) }

    subject { ref }

    describe 'accessors' do
      it_behaves_like 'test accessors when components schema/request_body ref'
    end

    describe '#parent' do
      it { expect(subject.parent).to be_nil }
    end
  end

  context 'when have parent' do
    let(:parent_data) do
      {
        type: :schema,
        path: '/api/v1/tasks',
        parent_schema_name: nil,
        depth: 0,
        tag_name: 'api/v1/tasks/{id}',
        verb: 'patch',
        http_status: '200',
        from: :path_item,
        schema_name: 'api.v1.Task_200_GET'
      }
    end

    let(:data) { described_class.new(parent_data) }
    let(:ref) { described_class.new(data) }

    subject { ref }

    describe 'accessors' do
      it_behaves_like 'test accessors when components schema/request_body ref'
    end

    describe '#parent' do
      it { expect(subject.parent).to eq data }
    end
  end
end
