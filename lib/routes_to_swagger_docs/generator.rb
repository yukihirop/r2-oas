require 'fileutils'
require_relative 'routing/parser'
require_relative 'schema/v3/openapi_object'
require_relative 'generator/base_generator'
require_relative 'generator/doc_generator'

module RoutesToSwaggerDocs
  class Generator < BaseGenerator
    def generate_docs
      DocGenerator.new.generate_docs
    end
  end
end
