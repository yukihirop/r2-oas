# frozen_string_literal: true

module R2OAS
  module Schema
    class PathItemFileManager
      extend Forwardable

      def_delegators :@manager, :skip_save?, :descendants_paths, :descendants_ref_paths

      def initialize(path, path_type = :ref)
        case ::R2OAS.version
        when :v3
          @manager = V3::PathItemFileManager.new(path, path_type)
        else
          raise "Do not support version: #{::R2OAS.version}"
        end
      end

      class << self
        alias build new
      end
    end
  end
end
