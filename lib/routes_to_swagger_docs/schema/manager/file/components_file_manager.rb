# frozen_string_literal: true

require_relative 'components/schema_file_manager'
require_relative 'components/request_body_file_manager'
require_relative 'components/security_scheme_file_manager'
require_relative 'components/parameter_file_manager'

module RoutesToSwaggerDocs
  module Schema
    class ComponentsFileManager
      class << self
        def build(path, path_type)
          new(path, path_type).builder
        end
      end

      def initialize(path, path_type = :ref)
        @path_type = path_type
        @original_path = path
        @pathname_manager = PathnameManager.new(path, path_type)
      end

      def builder
        case @pathname_manager.object_type
        when :schema
          Components::SchemaFileManager.new(@original_path, @path_type)
        when :request_body
          Components::RequestBodyFileManager.new(@original_path, @path_type)
        when :security_scheme
          Components::SecuritySchemeFileManager.new(@original_path, @path_type)
        when :parameter
          Components::ParameterFileManager.new(@original_path, @path_type)
        end
      end
    end
  end
end
