require 'fileutils'
require_relative 'routing/parser'
require_relative 'schema/v3/openapi_object'
require_relative 'client/base_client'
require_relative 'client/doc_client'

module RoutesToSwaggerDocs
  class Generator < BaseGenerator
    def generate_docs
      DocGenerator.new.generate_docs
    end
  end
end
