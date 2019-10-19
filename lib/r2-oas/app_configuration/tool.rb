# frozen_string_literal: true

require_relative 'tool/paths/stats'

module RoutesToSwaggerDocs
  module AppConfiguration
    class Tool
      DEFAULT_PATHS_STATS = PathsStats.new

      VALID_OPTIONS_KEYS = [
        :paths_stats
      ].freeze

      attr_accessor *VALID_OPTIONS_KEYS

      def initialize
        set_default
      end

      def configure
        yield self
      end

      private

      def set_default
        self.paths_stats = DEFAULT_PATHS_STATS
      end
    end
  end
end
