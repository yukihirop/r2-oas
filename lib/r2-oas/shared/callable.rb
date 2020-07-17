# frozen_string_literal: true

module R2OAS
  module Callable
    def deep_call(data, target, callback)
      return data unless data.is_a?(Hash)

      data.each do |key, value|
        if key.eql? target
          data[key] = callback.call(value)
        else
          data[key] = deep_call(value, target, callback)
        end
      end
    end
  end
end
