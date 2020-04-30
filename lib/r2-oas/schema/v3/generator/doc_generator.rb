# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require_relative 'base_generator'
require_relative 'schema_generator'

module R2OAS
  module Schema
    module V3
      class DocGenerator < BaseGenerator
        def initialize(options = {})
          super
          @schema_generator = SchemaGenerator.new(options)
        end

        def generate_docs
          logger.info '[Generate OAS schema files] start'
          @schema_generator.generate_docs
          logger.info '[Generate OAS schema files] end'
        end
      end
    end
  end
end
