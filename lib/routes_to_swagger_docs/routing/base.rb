module RoutesToSwaggerDocs
  module Routing
    class Base
      def initialize(*_args)
          options = RoutesToSwaggerDocs.options
        
          (Configuration::VALID_OPTIONS_KEYS).each do |key|
            send("#{key}=", options[key])
          end
        end

        private

        attr_accessor *Configuration::VALID_OPTIONS_KEYS
    end
  end
end