# frozen_string_literal: true

require_relative 'base_analyzer'
require_relative '../manager/file/path_item_file_manager'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class PathAnalyzer < BaseAnalyzer
      VERB = %w(get put post delete options head patch trace)
      NOT_VERB = %w($ref summary description servers parameters)

      def analyze_docs
        sorted_schema = deep_sort(@after_schema_data, 'paths')
        edited_paths_schema = sorted_schema['paths']

        save_each_tags(edited_paths_schema) do |tag_name, result|
          file_manager = PathItemFileManager.new("paths/#{tag_name}", :relative)
          file_manager.save(result.to_yaml)
          logger.info "  Write schema file: \t#{file_manager.save_file_path}"
        end
      end

      private

      def unit_paths_data_group_by_tags(unit_paths_data)
        unit_paths_data.each_with_object({}) do |(path, data_when_path), result|
          data_when_path.each do |verb_or_not, data_when_verb_or_not|
            if VERB.include?(verb_or_not)
              result = group_by_tags_when_verb(verb_or_not, data_when_verb_or_not, path, result)
            elsif NOT_VERB.include?(verb_or_not)
              result = group_by_tags_when_not_verb(verb_or_not, data_when_verb_or_not, path, result)
            else
              raise "Do not support path item object keys: #{verb_or_not}"
            end
          end
        end
      end

      def group_by_tags_when_verb(verb, data_when_verb, path, result)
        if !data_when_verb.is_a?(Array) && data_when_verb.has_key?('tags')
          tag_name = data_when_verb['tags'].first
        else
          tag_name = 'unknown'
          data_when_verb.deep_merge!({
            'tags' => [ tag_name ]
          })
        end

        result[tag_name] ||= {}
        result[tag_name].deep_merge!(
          'paths' => {
            path => {
              verb => data_when_verb
            }
          }
        )
        result
      end

      # The following pseudo tag names are after reservation
      # ・$ref
      # ・summary
      # ・description
      # ・servers
      # ・parameters
      def group_by_tags_when_not_verb(not_verb, data_when_not_verb, path, result)
        tag_name = not_verb
        result[tag_name] ||= {}
        result[tag_name].deep_merge!(
          'paths' => {
            path => {
              not_verb => data_when_not_verb
            }
          }
        )
        result
      end

      def save_each_tags(unit_paths_data)
        unit_paths_data_group_by_tags(unit_paths_data).each do |tag_name, result|
          yield [tag_name, result] if block_given?
        end
      end
    end
  end
end
