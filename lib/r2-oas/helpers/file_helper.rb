# frozen_string_literal: true

require 'fileutils'

# https :/ / keyesberry.hatenadiary.org / entry / 20101107 / p1
#
# Text attributes
# 0	All attributes off
# 1	Bold on
# 4	Underscore (on monochrome display adapter only)
# 5	Blink on
# 7	Reverse video on
# 8	Concealed on

# Foreground colors
# 30	Black
# 31	Red
# 32	Green
# 33	Yellow
# 34	Blue
# 35	Magenta
# 36	Cyan
# 37	White

# Background colors
# 40	Black
# 41	Red
# 42	Green
# 43	Yellow
# 44	Blue
# 45	Magenta
# 46	Cyan
# 47	White
module R2OAS
  module Helpers
    module FileHelper
      def write_file_or_skip(file_path, data, silent = false)
        unless FileTest.exists?(file_path)
          File.write(file_path, data)
          puts "#{space}#{bold('create')}\t#{relative(file_path)}" unless silent
        end
      end

      def mkdir_p_dir_or_skip(dir_path, silent = false)
        unless FileTest.exists?(dir_path)
          FileUtils.mkdir_p(dir_path)
          puts "#{space}#{bold('create')}\t#{relative(dir_path)}" unless silent
        end
      end

      private

      def relative(path)
        current_dir_pathname = Pathname.new(Dir.pwd)
        target_path = Pathname.new(path)
        target_path.relative_path_from(current_dir_pathname)
      end

      def bold(str)
        "\e[1m#{str}\e[0m"
      end

      def space
        '      '
      end
    end
  end
end
