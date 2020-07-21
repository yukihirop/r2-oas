# frozen_string_literal: true

# MEMO:
# copy from https://github.com/rails/rails/blob/master/activesupport/lib/active_support/deprecation/reporting.rb
module R2OAS
  class Deprecation
    module Reporting
      attr_accessor :silenced, :gem_name

      FILE_LINE_METHOD_REGEXP = /^(?<file>.+?):(?<line>\d+)(?::in `(?<method>.*?)')?/.freeze
      R2OAS_GEM_ROOT = File.expand_path('../../../../', __dir__) + '/lib'

      def warn(message = nil, callstack = nil)
        return if silenced

        callstack ||= caller_locations(2)
        deprecation_message(callstack, message).tap do |msg|
          behavior.each { |b| b.call(msg, callstack, deprecation_horizon, gem_name) }
        end
      end
      alias will_remove warn

      def silence
        old_silenced = silenced
        self.silenced = true
        yield if block_given?
        self.silenced = old_silenced
      end

      private

      def deprecation_message(callstack, message = nil)
        message ||= 'You are using deprecated behavior which will be removed from the next major or minor release.'
        "DEPRECATION WARNING: #{message} #{deprecation_caller_message(callstack)}"
      end

      def deprecation_caller_message(callstack)
        file, line, method = extract_callstack(callstack)
        if file
          if line && method
            "(called from #{method} at #{file}:#{line})"
          else
            "(called from #{file}:#{line})"
          end
        end
      end

      def extract_callstack(callstack)
        return _extract_callback(callstack) if callstack.first.is_a? String

        offending_line = callstack.find do |frame|
          frame.absolute_path && !ignored_callstack(frame.absolute_path)
        end || callstack.first

        [offending_line.path, offending_line.lineno, offending_line.label]
      end

      # e.g.)
      # callback = /path/to/file.rb:274:in `require'
      #
      # file = /path/to/file.rb
      # line = 274
      # method = require
      def _extract_callstack(_callback)
        warn 'Please pass `caller_options` to the deprecation API' if $VERBOSE
        offending_line = callstack.find { |line| !ignored_callstack(line) || callstack.first }

        if offendihng_line
          md = offending_line.match(FILE_LINE_METHOD_REGEXP)

          if md.present?
            md.captures
          else
            offending_line
          end
        end
      end

      # MEMO:
      # see https://docs.ruby-lang.org/ja/latest/class/RbConfig.html#C_-C-O-N-F-I-G
      def ignored_callstack(path)
        # MEMO:
        #
        # e.g.)
        # R2OAS_GEM_ROOT = "/Users/yukihirop/RubyProjects/r2-oas/lib"
        # rubylibprefix = "/Users/yukihirop/.rbenv/versions/2.7.1/lib/ruby"
        path.start_with?(R2OAS_GEM_ROOT) || path.start_with?(RbConfig::CONFIG['rubylibprefix'])
      end
    end
  end
end
