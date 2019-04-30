module RoutesToSwaggerDocs
  module Schema
    module V3
      class BaseObject
        def initialize(*_args)
          options = RoutesToSwaggerDocs.options
        
          (Configuration::VALID_OPTIONS_KEYS).each do |key|
            send("#{key}=", options[key])
          end
        end

        private

        attr_accessor *Configuration::VALID_OPTIONS_KEYS

        def to_doc
          raise 'Implement Inherit Class'
        end
      end
    end
  end
end