# frozen_string_literal: true

require 'fileutils'
require 'forwardable'
require 'r2-oas/routing/parser'
require_relative 'generator/doc_generator'
require_relative 'generator/base_generator'

module R2OAS
  module Schema
    module V3
      class Generator < BaseGenerator
        extend Forwardable

        def_delegators :@doc_generator, :generate_docs

        def initialize(options = {})
          super
          @doc_generator = DocGenerator.new(options)
        end
      end
    end
  end
end
