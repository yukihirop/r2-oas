# frozen_string_literal: true

module R2OAS
  module Schema
    module V3
      class Store
        attr_accessor :root_doc

        def initialize(type = :obj)
          @data = {}
          @data['type'] = type
          @data['data'] = {}
        end

        def add(obj_type, key, value)
          @data['data'][obj_type] ||= {}
          @data['data'][obj_type][key] ||= []
          @data['data'][obj_type][key].push(value)
        end

        def gets(obj_type)
          @data['data'][obj_type].present? ? @data['data'][obj_type].values.flatten : []
        end

        class << self
          extend Forwardable

          def_delegators :instance, :add, :gets

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
