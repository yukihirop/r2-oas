# frozen_string_literal: true

require 'routes_to_swagger_docs/version'
require 'routes_to_swagger_docs/configuration'
require 'routes_to_swagger_docs/errors'
require 'routes_to_swagger_docs/schema/v3/object/public'

module RoutesToSwaggerDocs
  extend ActiveSupport::Autoload

  if !defined?(::Rails)
    raise NoImplementError, 'Can not load Rails'
  # support Rails version
  elsif ::Rails::VERSION::STRING >= '4.2.5.1'
    extend Configuration
    require 'routes_to_swagger_docs/task'

    autoload :Base, 'routes_to_swagger_docs/base'
    autoload :NotImplementError, 'routes_to_swagger_docs/errors'
    autoload :Sortable, 'routes_to_swagger_docs/shared/all'

    module Schema
      extend ActiveSupport::Autoload

      autoload :Base, 'routes_to_swagger_docs/schema/base'
      autoload :Squeezer, 'routes_to_swagger_docs/schema/v3/squeezer'
      
      module V3
        extend ActiveSupport::Autoload

        autoload :Generator, 'routes_to_swagger_docs/schema/v3/generator'
        autoload :Analyzer, 'routes_to_swagger_docs/schema/v3/analyzer'
        autoload :Cleaner, 'routes_to_swagger_docs/schema/v3/cleaner'
      end
    end
  else
    raise NoImplementError, "Do not support Rails Version: #{::Rails::VERSION::STRING}"
  end
end
