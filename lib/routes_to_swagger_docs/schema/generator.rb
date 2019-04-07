require 'fileutils'
require_relative '../routing/parser'
require_relative 'generator/doc_generator'
require_relative 'generator/base_generator'

module RoutesToSwaggerDocs
  module Schema
    class Generator < BaseGenerator
      def initialize(schema_data = {}, options = {})
        super(schema_data, options)
        @doc_generator = DocGenerator.new(schema_data, unit_paths_file_path: unit_paths_file_path)
      end
      
      def generate_docs
        @doc_generator.generate_docs
      end
    end
  end
end
