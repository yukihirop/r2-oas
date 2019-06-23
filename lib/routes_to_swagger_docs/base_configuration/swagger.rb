#frozen_string_literal: true

require_relative 'swagger/ui'
require_relative 'swagger/editor'

module RoutesToSwaggerDocs
  module BaseConfiguration
    class Swagger
      DEFAULT_EDITOR = Editor.new
      DEFAULT_UI     = UI.new

      VALID_OPTIONS_KEYS = [
        :editor,
        :ui
      ]

      attr_accessor *VALID_OPTIONS_KEYS

      def initialize
        set_default
      end

      def configure
        yield self
      end

      private

      def set_default
        self.editor = DEFAULT_EDITOR
        self.ui     = DEFAULT_UI
      end
    end
  end
end