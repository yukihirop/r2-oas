require 'fileutils'
require 'forwardable'
require_relative '../routing/parser'
require_relative 'generator/doc_generator'
require_relative 'generator/base_generator'

module RoutesToSwaggerDocs
  module Schema
    class Generator < BaseGenerator
      extend Forwardable

      def_delegators :@doc_generator, :swagger_doc
      
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @doc_generator = DocGenerator.new(schema_data, options)
      end
      
      def generate_docs
        @doc_generator.generate_docs
      end
    end
  end
end
