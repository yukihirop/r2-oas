# frozen_string_literal: true

require 'spec_helper'
require 'r2-oas/routing/adjustor'

RSpec.describe R2OAS::Routing::Adjustor do
  let(:route_wrapper) { double('ActionDispatch::Routing::RouteWrapper') }
  let(:routes_data) do
    {
      route: route_wrapper,
      name: 'api_v1_tasks',
      verb: 'GET',
      path: '/api/v1/tasks/{id}(.:format)',
      reqs: 'api/v1/tasks#show'
    }
  end
  let(:adjustor) { described_class.new(routes_data) }

  after do
    reset_config
  end

  describe '#route_els' do
    context 'when rails normal routing' do
      before do
        allow(route_wrapper).to receive(:engine?).and_return(false)
      end

      context 'when namespace_type is :underbar' do
        it 'should return adjusted' do
          expect(adjustor.routes_els).to include(
            data: {
              format_name: '',
              path: '/api/v1/tasks/{id}',
              required_parameters: { id: { type: 'integer' } },
              schema_name: 'Api_V1_Task',
              tag_name: 'api/v1/task',
              verb: 'get'
            },
            path: '/api/v1/tasks/{id}'
          )
        end
      end

      context 'when namespace_type is :dot' do
        before do
          allow(R2OAS).to receive(:namespace_type).and_return(:dot)
        end

        it 'should return adjusted' do
          expect(adjustor.routes_els).to include(
            data: {
              format_name: '',
              path: '/api/v1/tasks/{id}',
              required_parameters: { id: { type: 'integer' } },
              schema_name: 'api.v1.Task',
              tag_name: 'api/v1/task',
              verb: 'get'
            },
            path: '/api/v1/tasks/{id}'
          )
        end
      end
    end

    context 'when rails engine routing' do
      let(:routes_data) do
        {
          route: route_wrapper,
          name: 'rails_subadmin',
          verb: '',
          path: '/subadmin',
          reqs: 'RailsAdmin::Engine'
        }
      end

      before do
        allow(route_wrapper).to receive(:engine?).and_return(true)
      end

      context 'when namespace_type is :underbar' do
        before do
          allow(R2OAS).to receive(:namespace_type).and_return(:underbar)
        end

        it 'should return adjusted' do
          expect(adjustor.routes_els).to include(
            data: {
              format_name: '',
              path: '/subadmin',
              required_parameters: {},
              schema_name: 'RailsAdmin_Engine',
              tag_name: 'rails_admin/engine',
              verb: 'get'
            },
            path: '/subadmin'
          )
        end
      end

      context 'when namespace_type is :dot' do
        before do
          allow(R2OAS).to receive(:namespace_type).and_return(:dot)
        end

        it 'should return adjusted' do
          expect(adjustor.routes_els).to include(
            data: {
              format_name: '',
              path: '/subadmin',
              required_parameters: {},
              schema_name: 'railsadmin.Engine',
              tag_name: 'rails_admin/engine',
              verb: 'get'
            },
            path: '/subadmin'
          )
        end
      end
    end
  end
end
