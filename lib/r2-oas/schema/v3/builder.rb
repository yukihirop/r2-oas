# frozen_string_literal: true

require 'fileutils'
require 'forwardable'
require 'r2-oas/routing/parser'
require_relative 'builder/doc_builder'
require_relative 'builder/base_builder'

module R2OAS
  module Schema
    module V3
      class Builder < BaseBuilder
        extend Forwardable

        def_delegators :@doc_builder, :oas_doc

        def initialize(options = {})
          super
          @doc_builder = DocBuilder.new(options)
        end

        def build_docs
          @doc_builder.build_docs
        end
      end
    end
  end
end
