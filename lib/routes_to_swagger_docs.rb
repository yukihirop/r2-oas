# frozen_string_literal: true

require_relative 'routes_to_swagger_docs/version'
require_relative 'routes_to_swagger_docs/configuration'
require_relative 'routes_to_swagger_docs/errors'
require_relative 'routes_to_swagger_docs/schema/v3/object/public'

module RoutesToSwaggerDocs
  if !defined?(::Rails)
    raise NoImplementError, 'Can not load Rails'
  # support Rails version
  elsif ::Rails::VERSION::STRING >= '4.2.5.1'
    extend Configuration
    require_relative 'routes_to_swagger_docs/task'
  else
    raise NoImplementError, "Do not support Rails Version: #{::Rails::VERSION::STRING}"
  end
end
