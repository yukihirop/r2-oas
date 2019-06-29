# frozen_string_literal: true

module RoutesToSwaggerDocs
  module BaseConfiguration
    class Tool
      class PathsStats
        DEFAULT_MONTH_TO_TURN_TO_WARNING_COLOR = 3
        DEFAULT_WARNING_COLOR = :red
        DEFAULT_TABLE_TITLE_COLOR = :yellow
        DEFAULT_HEADING_COLOR = :yellow

        VALID_OPTIONS_KEYS = %i[
          month_to_turn_to_warning_color
          warning_color
          table_title_color
          heading_color
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
          self.month_to_turn_to_warning_color = DEFAULT_MONTH_TO_TURN_TO_WARNING_COLOR
          self.warning_color                  = DEFAULT_WARNING_COLOR
          self.table_title_color              = DEFAULT_TABLE_TITLE_COLOR
          self.heading_color                  = DEFAULT_HEADING_COLOR
        end
      end
    end
  end
end
