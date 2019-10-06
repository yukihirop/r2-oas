# frozen_string_literal: true

require_relative 'base_file_manager'
require_relative '../pathname_manager'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class IncludeRefBaseFileManager < BaseFileManager
        REF = '$ref'

        def initialize(path, path_type = :ref)
          super
          @convert_underscore_to_slash = true
          @parent_save_file_paths = []
          @recursive_search_class = self.class
        end

        class << self
          alias :build :new
        end

        def descendants_paths
          results = []

          deep_search_ref_recursive(load_data) do |relative_paths|
            results.push(*relative_paths)
          end

          results.uniq
        end
        alias descendants_ref_paths descendants_paths

        private

        attr_accessor :parent_save_file_paths, :recursive_search_class

        def deep_search_ref_recursive(yaml, &block)
          if yaml.is_a?(Hash)
            yaml.each do |key, value|
              process_deep_search_ref_recursive(key, value, &block)
            end
          # Support allOf/oneOf/anyOf
          elsif yaml.is_a?(Array)
            yaml.each do |el|
              next unless el.is_a?(Hash)

              el.each do |key, value|
                process_deep_search_ref_recursive(key, value, &block)
              end
            end
          end
        end

        def process_deep_search_ref_recursive(ref_key_or_not, ref_value_or_not, &block)
          # Don't pick up JSON Schema $ref
          # e.x.)
          #  $ref: { "type" => "string" }
          if (ref_key_or_not.eql? REF) && (ref_value_or_not.to_s.start_with?("#/"))
            
            # Avoid $ ref circular references
            pm = PathnameManager.new(ref_value_or_not, :ref)
            relative_save_file_path = pm.relative_save_file_path
            
            if @parent_save_file_paths.include?(relative_save_file_path)
              return
            else
              @parent_save_file_paths.push(relative_save_file_path)
            end

            child_file_manager = @recursive_search_class.build(ref_value_or_not, :ref)
            child_load_data = child_file_manager.load_data

            children_paths = []
            deep_search_ref_recursive(child_load_data) do |children_path|
              children_paths.push(*children_path)
            end

            results = [child_file_manager.save_file_path] + children_paths
            yield results if block_given?
          else
            deep_search_ref_recursive(ref_value_or_not, &block)
          end
        end
      end
    end
  end
end
