# frozen_string_literal: true

module R2OAS
  module Schema
    module V3
      class Store
        attr_accessor :root_doc
        attr_accessor :components_schema_name_list, :appended_components_schema_name_list
        attr_accessor :components_request_body_name_list, :appended_components_request_body_name_list

        def initialize(type = :obj)
          @data = {}
          @data['type'] = type
          @data['data'] = {}
          @root_doc = {}
          @components_schema_name_list = []
          @appended_components_schema_name_list = []
          @components_request_body_name_list = []
          @appended_components_request_body_name_list = []
        end

        def add(obj_type, key, value)
          @data['data'][obj_type] ||= {}
          # MEMO:
          # Do not save the same thing in store by using unique contents for schema name
          @data['data'][obj_type][key] ||= value
        end

        def gets(obj_type)
          (@data['data'][obj_type] || {}).values.present? ? @data['data'][obj_type].values : []
        end

        class << self
          extend Forwardable

          def_delegators :instance, :add, :gets, :root_doc
          def_delegators :instance, :components_schema_name_list, :appended_components_schema_name_list
          def_delegators :instance, :components_request_body_name_list, :appended_components_request_body_name_list

          def create(type = :obj)
            instance(type)
          end

          private

          def instance(type)
            @instance ||= {}
            @instance[type] ||= new(type)
          end
        end
      end
    end
  end
end
