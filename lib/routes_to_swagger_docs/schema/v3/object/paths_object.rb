# frozen_string_literal: true

require_relative '../../plugins/schema/object/hookable_base_object'

module RoutesToSwaggerDocs
  module Schema
    module V3
      class PathsObject < RoutesToSwaggerDocs::Plugins::Schema::V3::HookableBaseObject
        def initialize(routes_data)
          super()
          @routes_data = routes_data
          define_hookable_tmp_object_class
        end

        def create_doc
          if unit_paths_file_path.present?
            unit_paths_data = YAML.load_file(unit_paths_file_path)['paths']
            result = unit_paths_data.each_with_object({}) do |(path, path_item_doc), docs|
              docs[path] = HookableTmpObjectClass.new(path_item_doc, path).to_doc
            end
          else
            result = path_item_docs.each_with_object({}) do |(path, path_item_doc), docs|
              docs[path] = path_item_doc
            end
          end
          doc.merge!(result)
        end

        private

        def define_hookable_tmp_object_class
          klass = Class.new(path_item_object_class) do |_c|
            def initialize(data, path)
              super
              @data = data
              @path = path
              use_superclass_hook
            end

            def create_doc
              doc.merge!(@data)
            end

            def to_doc
              execute_before_create(@path)
              create_doc
              execute_after_create(@path)
              doc
            end
          end
          Object.const_set(:HookableTmpObjectClass, klass)
        end

        def path_item_docs
          # e.x.)
          # [
          #  { path: "/tasks", data: {:verb=>"get", :path=>"/tasks", :tag_name=>"task" } },
          # ]
          @routes_data.each_with_object({}) do |(route_el), data|
            path = route_el[:path]
            route_data = route_el[:data]

            path_item_doc = path_item_object_class.new(route_data, path).to_doc
            if data[path].present?
              data[path].merge!(path_item_doc)
            else
              data[path] = path_item_doc
            end
          end
        end
      end
    end
  end
end
