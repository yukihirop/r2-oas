# frozen_string_literal: true

require 'r2-oas/schema/v3/manager/file_manager'

module R2OAS
  module Schema
    class FileManager
      extend Forwardable

      def_delegators :@manager, :save, :delete

      def initialize(path, path_type = :ref)
        case ::R2OAS.version
        when :v3
          @manager = V3::FileManager.new(path, path_type)
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
