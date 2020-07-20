module R2OAS
  module Schema
    module V3
      module FromFiles
        module DeepMethods
          def deep_replace!(data, target, &blk)
            return unless data.is_a?(Hash)

            data.each do |key, value|
              if key.eql? target
                # MEMO:
                # When using the same schema, it has already been replaced by an object
                if value.is_a?(String)
                  data[key] = block_given? ? yield(value) : value
                end
              else
                deep_replace!(value, target, &blk)
              end
            end
          end
        end
      end
    end
  end
end
