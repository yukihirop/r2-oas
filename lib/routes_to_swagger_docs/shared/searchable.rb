module RoutesToSwaggerDocs
  module Searchable
    def deep_search(yaml, target, &block)
      if yaml.is_a?(Hash)
        yaml.keys.each do |key|
          if key.eql? target
            yield yaml[key] if block_given?
          else
            deep_search(yaml[key], target, &block)
          end
        end
      end
    end
  end
end
