# frozen_string_literal: true

require_relative '../../base'
require_relative '../../../shared/all'
require_relative '../../../errors'

module RoutesToSwaggerDocs
  module Schema
    class BaseHashDiffManager < BaseDiffManager
      include Sortable

      def initialize(before_schema_data, after_schema_data)
        super
        @major_category     = 'base'
        @middle_category    = ''
      end

      def process_by_using_diff_data
        before_target_data       = sorted_target_data(@before_schema_data)
        before_target_data_names = before_target_data.keys.uniq
        after_target_data        = sorted_target_data(@after_schema_data)
        after_target_data_names  = after_target_data.keys.uniq
        target_names             = (before_target_data_names + after_target_data_names).uniq

        target_names.each do |target_name|
          before_schema_data = schema_data_at(before_target_data, target_name)
          after_schema_data = schema_data_at(after_target_data, target_name)

          removed, added = before_schema_data.easy_diff(after_schema_data)
          leftovers, _   = before_schema_data.easy_diff(removed)

          is_removed   = to_boolean(removed, target_name)
          is_added     = to_boolean(added, target_name)
          is_leftovers = to_boolean(leftovers, target_name)

          yield(target_name, is_removed, is_added, is_leftovers, after_schema_data) if block_given?
        end
      end

      private

      def normalized(data)
        if data.present?
          data
        elsif @middle_category.present?
          { @major_category => { @middle_category => {} } }
        else
          { @major_category => {} }
        end
      end

      def schema_data_at(data, key)
        if @middle_category.present?
          {
            @major_category => {
              @middle_category => {
                key => data.fetch(key, nil)
              }
            }
          }
        else
          {
            @major_category => {
              key => data.fetch(key, nil)
            }
          }
        end
      end

      def sorted_target_data(data)
        data = ensure_presence_or_blank(data)

        if @middle_category.present?
          sorted_data = deep_sort(data[@major_category], @middle_category)
          result = ensure_presence_or_blank(sorted_data[@middle_category])
        else
          sorted_data = deep_sort(data, @major_category)
          result = ensure_presence_or_blank(sorted_data[@major_category])
        end

        result
      end

      def to_boolean(diff, target_name)
        if diff.present?
          diff[@major_category][@middle_category][target_name].present?
        else
          false
        end
      end
    end
  end
end
