# frozen_string_literal: true

module R2OAS
  module Callable
    def deep_call(data, target, callback)
      if data.is_a?(Hash)
        data.each do |key, value|
          data[key] = if key.eql? target
                        callback.call(value)
                      else
                        deep_call(value, target, callback)
                      end
        end
      else
        data
      end
    end
  end
end
