module RoutesToSwaggerDocs
  module Sortable
    def deep_sort(data, target)
      if data.is_a?(Hash)
        data.each_with_object({}) do |(key, value), result|
          if key.eql? target
            if value.is_a?(Hash)
              result[key] = Hash[ value.sort ]
            else
              result[key] = value
            end
          else
            result[key] = deep_sort(value, target)
          end
        end
      else
        data
      end
    end
  end
end
