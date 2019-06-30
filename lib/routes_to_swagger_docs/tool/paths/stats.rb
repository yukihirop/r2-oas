# frozen_string_literal: true

require_relative '../../base'
require 'terminal-table'
require 'paint'
require 'forwardable'

module RoutesToSwaggerDocs
  module Tool
    module Paths
      class Stats < Base
        extend Forwardable

        TIMESTAMPS = ['Created At', 'Updated At'].freeze
        TABLE_TITLE = 'Paths Stats'

        def initialize(options)
          super
          @paths_list = Dir.glob("#{schema_save_dir_path}/paths/**/**.yml")
          @path_from = Pathname(File.dirname(File.expand_path(root_dir_path)))
          @paths_stats = tool.paths_stats
        end

        def print
          table.title = Paint[TABLE_TITLE, table_title_color]
          puts table
          puts "\n#{Paint['Red', warning_color]}: over #{month_to_turn_to_warning_color} months since the last update."
        end

        private

        def_delegators :@paths_stats, :month_to_turn_to_warning_color, :warning_color, :table_title_color, :heading_color, :highlight_color

        def table
          @table ||= Terminal::Table.new do |t|
            @paths_list.each_with_index do |file_path, index|
              t.headings = ['No', 'File Path', *TIMESTAMPS].map { |head| Paint[head, heading_color] }
              t << table_content(index, file_path)
              t.style = { all_separators: true }
            end
          end
        end

        def table_content(index, file_path)
          content = [(index + 1).to_s, relative_file_path(file_path), *timestamps(file_path)]
          if file_path.in? paths_config.many_paths_file_paths
            content.map { |c| Paint[c, highlight_color] }
          else
            content
          end
        end

        def relative_file_path(file_path)
          path_to = Pathname(file_path)
          path_to.relative_path_from(@path_from).to_s
        end

        def timestamps(file_path)
          timestamps_data(file_path) do |result, stat|
            mtime = stat.mtime
            result.deep_merge!(
              mtime: expired?(mtime) ? Paint[mtime, warning_color] : mtime
            )
          end.values
        end

        def timestamps_data(file_path)
          stat = File::Stat.new(file_path)
          result = {
            birthtime: stat.birthtime,
            mtime: stat.mtime
          }
          yield result, stat if block_given?
          result
        end

        def expired?(mtime)
          month = month_to_turn_to_warning_color.send(:month)
          expired_at = Time.current.ago(month)
          mtime < expired_at
        end
      end
    end
  end
end
