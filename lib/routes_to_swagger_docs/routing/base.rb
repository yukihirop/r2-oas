module RoutesToSwaggerDocs
  module Routing
    class Base
      def initialize(schema_data = {}, options = {})
        merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        (BaseConfiguration::VALID_OPTIONS_KEYS + options.keys).each do |key|
          send("#{key}=", merged_options[key])
        end
      end

      private

      attr_accessor *BaseConfiguration::VALID_OPTIONS_KEYS
    end
  end
end