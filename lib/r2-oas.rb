# frozen_string_literal: true

require 'r2-oas/version'
require 'r2-oas/public'

module R2OAS
  if !defined?(::Rails)
    raise NoImplementError, 'Can not load Rails'
  # support Rails version
  elsif ::Rails::VERSION::STRING >= '4.2.5.1'
    extend Configuration
    require 'r2-oas/task'
    require 'r2-oas/plugin/public'
    require 'r2-oas/lib/core_ext/all'

    autoload :Base, 'r2-oas/base'
    autoload :NoImplementError, 'r2-oas/errors'
    autoload :NoFileExistsError, 'r2-oas/errors'
    autoload :NoSupportError, 'r2-oas/errors'
    autoload :Sortable, 'r2-oas/shared/all'
    autoload :Deprecation, 'r2-oas/support/deprecation'

    module Schema
      autoload :Base, 'r2-oas/schema/base'
      autoload :Generator, 'r2-oas/schema/generator'
      autoload :Builder, 'r2-oas/schema/builder'
      autoload :Analyzer, 'r2-oas/schema/analyzer'
      autoload :Squeezer, 'r2-oas/schema/squeezer'
      autoload :Cleaner, 'r2-oas/schema/cleaner'
    end
  else
    raise NoImplementError, "Do not support Rails Version: #{::Rails::VERSION::STRING}"
  end
end
