# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Base
      def initialize(options = {})
        merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        (Configuration::VALID_OPTIONS_KEYS + options.keys).each do |key|
          send("#{key}=", merged_options[key])
        end
      end

      private

      attr_accessor *Configuration::VALID_OPTIONS_KEYS
    end
  end
end