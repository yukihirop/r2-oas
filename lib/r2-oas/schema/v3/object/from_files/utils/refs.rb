# frozen_string_literal: true

require 'r2-oas/errors'

module R2OAS
  module Schema
    module V3
      module FromFiles
        class BaseRef
          def pretty_print(q)
            pp_hash(q, to_h)
          end
          
          def parent
            @parent
          end
          
          def []=(key, value)
            unless writable_keys.include?(key)
              display_key = key.is_a?(Symbol) ? ":#{key}" : key
              raise ::R2OAS::RefInvalidAssignment, "invalid method `[#{display_key}]=' called for #{self}"
            end
            send(:"#{key}=", value)
            value
          end
          
          def [](key)
            send(key)
          end
          
          def to_h
            valid_keys.each_with_object({}) do |key, result|
              result[key] = send(key)
            end
          end
          
          private
        
          # MEMO:
          # https://apidock.com/ruby/v1_9_3_392/PP/PPMethods/pp_hash
          def pp_hash(q, obj)
            q.group(1, '{', '}') {
              q.seplist(obj, nil, :each_pair) {|k, v|
                q.group {
                  q.pp k
                  q.text '=>'
                  q.group(1) {
                    q.breakable ''
                    q.pp v
                  }
                }
              }
            }
          end
          
          def build(ref_or_data, merge_data = {})
            data = ref_or_data.to_h.merge(merge_data)
            data.keys.each do |key|
              instance_variable_set(:"@#{key}", data[key])
            end
            
            if ref_or_data.respond_to?(:parent)
              @parent = ref_or_data
            end
          end
          
          def parent=(parent)
            @parent = parent
            self
          end
          
          def valid_keys
            raise NoImplementError, 'Please implement in inherited class.'
          end
          
          def writable_keys
            raise NoImplementError, 'Please implement in inherited class.'
          end
        end
        
        class PathRef < BaseRef
          VALID_KEYS = [ :type, :path ].freeze
          
          attr_reader *VALID_KEYS
          
          def initialize(data)
            build(data, { type: :path_item })
          end
          
          private
          
          attr_writer *VALID_KEYS
          
          def valid_keys
            VALID_KEYS
          end
          
          def writable_keys
            []
          end
        end
        
        module Components
          class SchemaRef < BaseRef
            READONLY_KEYS = [ :type, :path, :parent_schema_name, :depth, :tag_name, :verb, :http_status, :from ].freeze
            WRITABLE_KEYS = [ :schema_name ].freeze
            VALID_KEYS = READONLY_KEYS + WRITABLE_KEYS
            
            attr_reader *VALID_KEYS
            attr_writer *WRITABLE_KEYS
            
            def initialize(ref_or_data)
              build(ref_or_data, { type: :schema })
            end
            
            private
            
            attr_writer *READONLY_KEYS
            
            def valid_keys
              VALID_KEYS
            end
            
            def writable_keys
              WRITABLE_KEYS
            end
          end
          
          class RequestBodyRef < BaseRef
            READONLY_KEYS = [ :type, :path, :parent_schema_name, :depth, :tag_name, :verb, :from ].freeze
            WRITABLE_KEYS = [ :schema_name ].freeze
            VALID_KEYS = READONLY_KEYS + WRITABLE_KEYS
            
            attr_accessor *VALID_KEYS
            attr_writer *WRITABLE_KEYS
            
            def initialize(ref_or_data)
              build(ref_or_data, { type: :request_body })
            end
            
            private
            
            attr_writer *READONLY_KEYS
            
            def valid_keys
              VALID_KEYS
            end
            
            def writable_keys
              WRITABLE_KEYS
            end
          end
        end
      end
    end
  end
end
