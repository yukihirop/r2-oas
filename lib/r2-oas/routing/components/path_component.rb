# frozen_string_literal: true

require_relative 'base_component'

module R2OAS
  module Routing
    class PathComponent < BaseComponent
      FORMAT_PATH_PARAMETER_REGEXP = /\(.+\)/.freeze
      SYMBOL_PATH_PARAMETER_REGEXP = /:(.\w+)/.freeze
      BRACE_PATH_PARAMETER_REGEXP  = /\{(.\w+)\}/.freeze

      def initialize(path)
        super()
        @path = path
      end

      def to_s
        without_format.to_s
      end

      def symbol_to_brace
        return without_format unless exist_path_parameters?

        path_parameters.each_with_object(without_format) do |path_parameter, result|
          result.gsub!(":#{path_parameter}", "{#{path_parameter}}")
        end
      end

      def path_parameters_data
        return {} unless exist_path_parameters?

        path_parameters.each_with_object({}) do |path_parameter, data|
          type = (path_parameter =~ /id/ ? 'integer' : 'string')
          data.merge!(
            "#{path_parameter}": {
              type: type
            }
          )
        end
      end

      def path_excluded_path_parameters
        excluded_path_parameters = path_parameters.each_with_object(symbol_to_brace) do |path_parameter, result|
          result.gsub!("{#{path_parameter}}", '')
        end
        excluded_path_parameters.split('/').delete_if(&:empty?).join('/')
      end

      def exist_path_parameters?
        path_parameters.present?
      end

      def path_parameters
        result = without_format.scan(SYMBOL_PATH_PARAMETER_REGEXP) + without_format.scan(BRACE_PATH_PARAMETER_REGEXP)
        result.flatten
      end

      private

      # e.x.) "/tasks(.:format)" => "/tasks"
      # e.x.) "/:model_name/:id/show_in_app(.:format)" => "/{model_name}/{id}/show_in_app"
      def without_format
        @path.gsub(FORMAT_PATH_PARAMETER_REGEXP, '')
      end
    end
  end
end
