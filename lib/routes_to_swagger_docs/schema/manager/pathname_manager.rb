# frozen_string_literal: true

require_relative '../base'

module RoutesToSwaggerDocs
  module Schema
    class PathnameManager < Base
      COMPONENTS_OBJECTS = %i(schemas requestBodies securitySchemes parameters)

      # e.x.) path = "#/components/schemas/Account" (when path_type = :ref)
      def initialize(path, path_type = :full)
        super()
        @ext_name = :yml
        @path_type = path_type
        @path = path
      end

      def object_type
        case @path
        when /schemas/
          :schemas
        when /requestBodies/
          :requestBodies
        when /securitySchemes/
          :securitySchemes
        when /parameters/
          :parameters
        end
      end

      def relative_save_file_path
        result = normalized_about_path_type
        if (@path_type.in? %i[ref relative]) && (COMPONENTS_OBJECTS.include?(object_type))
          dirname = File.dirname(result)
          basename = File.basename(result, '.yml')
          basename = basename.gsub(ns_div, '/').underscore
          "#{schema_save_dir_path}/#{dirname}/#{basename}.yml"
        elsif @path_type.eql?(:relative) && !(COMPONENTS_OBJECTS.include?(object_type))
          "#{schema_save_dir_path}/#{result.underscore}"
        elsif @path_type.eql?(:full)
          result
        else
          "#{schema_save_dir_path}/#{result}"
        end
      end

      private

      def normalized_about_path_type
        case @path_type
        when :ref
          "#{@path.gsub('#/', '')}.#{@ext_name}"
        when :relative
          "#{@path}.#{@ext_name}"
        when :full
          @path
        end
      end
    end
  end
end
