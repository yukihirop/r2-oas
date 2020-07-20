# frozen_string_literal: true

require 'r2-oas/shared/callable'
require 'r2-oas/errors'
require_relative '../base_object'
require_relative 'schema_object'
require_relative '../utils/all'

module R2OAS
  module Schema
    module V3
      module FromFiles
        module Components
          class RequestBodyObject < ::R2OAS::Schema::V3::FromFiles::BaseObject
            include ::R2OAS::Callable
            include DeepMethods

            def initialize(doc, ref, opts)
              super(opts)
              @doc = doc
              @parent_ref = Components::RequestBodyRef.new(ref)
              resolve_dependencies!
            end

            def to_doc
              call_ref_path!

              # MEMO:
              # If it is overwritten, it may lead to unexpected problems, so give a copy
              execute_transform_plugins(:components_request_body, @doc, ref_dup)
              @doc
            end

            def resolve_dependencies!
              deep_replace!(@doc, '$ref') do |ref_path|
                schema_obj, schema_type, pure_schema_name = ref_path.split('/').slice(1..-1)
                schema_doc = root_doc&.fetch(schema_obj, nil)&.fetch(schema_type, nil)&.fetch(pure_schema_name, nil) || {}
                
                ref = create_child_ref(pure_schema_name)
                obj = Components::SchemaObject.new(schema_doc, ref, opts)

                obj_store.add('components/schemas', pure_schema_name, obj)
                obj
              end
            end

            def call_ref_path!
              callback = proc { |obj| obj.ref_path }
              deep_call(@doc, '$ref', callback)
            end

            def schema_name
              return @resolved_schema_name if @resolved_schema_name.present?

              before_schema_name = ref_dup[:schema_name]

              _ref_dup = ref_dup
              execute_transform_plugins(:components_request_body_name, _ref_dup)
              @resolved_schema_name = _ref_dup[:schema_name]

              if before_schema_name != @resolved_schema_name
                if reserved_schema_name_list.include?(@resolved_schema_name)
                  raise DepulicateSchemaNameError, "Transformed schema name: '#{@resolved_schema_name}' cannot be used. It already exists."
                else
                  obj_store.appended_components_request_body_name_list.push(@resolved_schema_name)
                end
              end

              @resolved_schema_name
            end

            def ref_path
              "#/components/requestBodies/#{schema_name}"
            end

            private

            def ref_dup
              @parent_ref.dup
            end

            def reserved_schema_name_list
              (
                obj_store.components_request_body_name_list +
                obj_store.appended_components_request_body_name_list
              ).uniq
            end
            
            def create_child_ref(schema_name)
              local_ref_hash = ref_dup.to_h
              parent_schema_name = local_ref_hash[:schema_name]
              depth = local_ref_hash[:depth] + 1
              ref_data = local_ref_hash.merge({ from: :request_body, schema_name: schema_name, parent_schema_name: parent_schema_name, depth: depth })
              ref = Components::SchemaRef.new(ref_data)
              ref.send(:parent=, ref_dup)
              ref
            end
          end
        end
      end
    end
  end
end
