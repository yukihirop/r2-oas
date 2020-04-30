# frozen_string_literal: true

require 'r2-oas/deploy/client'
require 'r2-oas/tool/paths/ls'
require 'r2-oas/tool/paths/stats'
require 'r2-oas/task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :oas do
    desc 'Deploy Swagger UI'
    task deploy: [:common] do
      start do
        builder_options = { unit_paths_file_path: unit_paths_file_path }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        client_options = {}
        client = R2OAS::Deploy::Client.new(client_options)
        client.deploy
      end
    end

    desc 'Display paths list'
    task paths_ls: [:common] do
      fd = IO.sysopen('/dev/null', 'w+')
      $stdout = IO.new(fd)
      logger.level = :null

      start do
        $stdout = StringIO.new

        paths_ls_options = {}
        paths_ls = R2OAS::Tool::Paths::Ls.new(paths_ls_options)
        paths_ls.print
      end

      result = $stdout.string
      $stdout = STDOUT
      puts result
    end

    desc 'Display paths stats'
    task paths_stats: [:common] do
      fd = IO.sysopen('/dev/null', 'w+')
      $stdout = IO.new(fd)
      logger.level = :null

      start do
        builder_options = { skip_load_dot_paths: true }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        $stdout = StringIO.new

        paths_log_options = {}
        paths_log = R2OAS::Tool::Paths::Stats.new(paths_log_options)
        paths_log.print
      end

      result = $stdout.string
      $stdout = STDOUT
      puts result
    end

    private

    def unit_paths_file_path
      ENV.fetch('PATHS_FILE', '')
    end

    def existing_schema_file_path
      ENV.fetch('OAS_FILE', '')
    end
  end
end
