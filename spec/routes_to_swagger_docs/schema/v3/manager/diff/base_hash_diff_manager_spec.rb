# frozen_string_literal: true

require 'spec_helper'
require 'routes_to_swagger_docs/schema/v3/manager/diff/base_hash_diff_manager'

RSpec.describe RoutesToSwaggerDocs::Schema::V3::BaseHashDiffManager do
  let(:before_schema_data) do
    {
      'base' => {
        'middle' => {
          'a_00' => {
            'b_00' => 'c_00'
          },
          'a_01' => 'b_01'
        }
      }
    }
  end

  let(:after_schema_data) do
    {
      'base' => {
        'middle' => {
          'a_00' => {
            'b_00' => 'c_00'
          },
          'a_02' => {
            'b_02' => 'c_02'
          }
        }
      }
    }
  end

  let(:manager) { described_class.new(before_schema_data, after_schema_data) }

  describe '#process_by_using_diff_data' do
    context 'when block is not given' do
      it { expect(manager.process_by_using_diff_data).to be_nil }
    end

    context 'when block is given' do
      before do
        @result = []
        manager.process_by_using_diff_data do |target_name, is_removed, is_added, is_leftovers, after_schema_data|
          @result.push(
            target_name: target_name,
            is_removed: is_removed,
            is_added: is_added,
            is_leftovers: is_leftovers,
            after_schema_data: after_schema_data
          )
        end
      end

      context 'when modified' do
        let(:before_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_00' => {
                  'b_00' => 'c_00'
                },
                'a_01' => 'b_01'
              }
            }
          }
        end

        let(:after_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_00' => {
                  'b_00' => 'd_00'
                },
                'a_01' => 'd_01'
              }
            }
          }
        end

        it do
          expect(@result).to include(
            {
              after_schema_data: { 'base' => { 'middle' => { 'a_00' => { 'b_00' => 'd_00' } } } },
              is_added: true,
              is_leftovers: false,
              is_removed: true,
              target_name: 'a_00'
            },
            after_schema_data: { 'base' => { 'middle' => { 'a_01' => 'd_01' } } },
            is_added: true,
            is_leftovers: false,
            is_removed: true,
            target_name: 'a_01'
          )
        end
      end

      context 'when added' do
        let(:before_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_00' => {
                  'b_00' => 'c_00'
                },
                'a_01' => 'b_01'
              }
            }
          }
        end

        let(:after_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_00' => {
                  'b_00' => 'c_00'
                },
                'a_01' => 'b_01',
                'a_02' => 'b_02'
              }
            }
          }
        end

        it do
          expect(@result).to include(
            {
              after_schema_data: { 'base' => { 'middle' => { 'a_00' => { 'b_00' => 'c_00' } } } },
              is_added: false,
              is_leftovers: true,
              is_removed: false,
              target_name: 'a_00'
            },
            {
              after_schema_data: { 'base' => { 'middle' => { 'a_01' => 'b_01' } } },
              is_added: false,
              is_leftovers: true,
              is_removed: false,
              target_name: 'a_01'
            },
            after_schema_data: { 'base' => { 'middle' => { 'a_02' => 'b_02' } } },
            is_added: true,
            is_leftovers: false,
            is_removed: false,
            target_name: 'a_02'
          )
        end
      end

      context 'when removed' do
        let(:before_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_00' => {
                  'b_00' => 'c_00'
                },
                'a_01' => 'b_01'
              }
            }
          }
        end

        let(:after_schema_data) do
          {
            'base' => {
              'middle' => {
                'a_01' => 'b_01'
              }
            }
          }
        end

        it do
          expect(@result).to include(
            {
              after_schema_data: { 'base' => { 'middle' => { 'a_00' => nil } } },
              is_added: false,
              is_leftovers: false,
              is_removed: true,
              target_name: 'a_00'
            },
            after_schema_data: { 'base' => { 'middle' => { 'a_01' => 'b_01' } } },
            is_added: false,
            is_leftovers: true,
            is_removed: false,
            target_name: 'a_01'
          )
        end
      end
    end
  end
end
