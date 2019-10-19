# frozen_string_literal: true

module RoutesToSwaggerDocs
  module Sortable
    def deep_sort(data, target)
      if data.is_a?(Hash)
        data.each_with_object({}) do |(key, value), result|
          result[key] = if key.eql? target
                          if value.is_a?(Hash)
                            Hash[value.sort]
                          else
                            value
                                        end
                        else
                          deep_sort(value, target)
                        end
        end
      else
        data
      end
    end
  end
end
