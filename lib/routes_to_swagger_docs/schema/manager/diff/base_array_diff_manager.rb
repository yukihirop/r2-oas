require_relative 'base_diff_manager'

module RoutesToSwaggerDocs
  module Schema
    class BaseArrayDiffManager < BaseDiffManager

      def initialize(before_schema_data, after_schema_data)
        super
        @major_category = 'base'
        @judge_key      = ''
      end
      
      def process_by_using_diff_data(&block)
        before_data_at_major         = @before_schema_data[@major_category]
        after_data_at_major          = @after_schema_data[@major_category]
        after_schema_data_grouped_by = schema_data_grouped_by_judge_key(after_data_at_major)

        result = before_data_at_major.map do |data|
          judge_name = data[@judge_key]
          if judge_name.in? after_schema_data_grouped_by.keys
            after_schema_data_grouped_by[judge_name]
          else
            data
          end
        end

        yield schema_data_at(result) if block_given?
      end

      def after_target_data
        schema_data_at(@after_schema_data[@major_category])
      end
      
      private
      
      def schema_data_grouped_by_judge_key(arr)
        arr.each_with_object({}) do |data, result|
          result.deep_merge!({ data[@judge_key] => data })
        end
      end
      
      def schema_data_at(data)
        {
          @major_category => data
        }
      end

      def to_boolean(diff)
        if diff.present?
          diff[@major_category].present?
        else
          false
        end
      end
    end
  end
end
