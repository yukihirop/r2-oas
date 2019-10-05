# frozen_string_literal: true

require_relative '../base'

module RoutesToSwaggerDocs
  module Schema
    class PathnameManager < Base
      SCHEMA          = 'schemas'
      REQUEST_BODY    = 'requestBodies'
      SECURITY_SCHEME = 'securitySchemes'
      PARAMETER       = 'parameters' 

      # e.x.) path = "#/components/schemas/Account" (when path_type = :ref)
      def initialize(path, path_type = :full)
        super()
        @ext_name = :yml
        @path_type = path_type
        @path = path
      end

      def object_type
        case @path
        when /#{SCHEMA}/
          :schema
        when /#{REQUEST_BODY}/
          :request_body
        when /#{SECURITY_SCHEME}/
          :security_scheme
        when /#{PARAMETER}/
          :parameter
        end
      end

      def relative_save_file_path
        result = normalized_about_path_type
        if (@path_type.in? %i[ref relative]) && (object_type.in? %i[schema request_body security_scheme parameter])
          dirname = File.dirname(result)
          basename = File.basename(result, '.yml')
          basename = basename.gsub(ns_div, '/').underscore
          "#{schema_save_dir_path}/#{dirname}/#{basename}.yml"
        elsif @path_type.eql?(:relative) && !(object_type.in? %i[schema request_body security_scheme parameter])
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
