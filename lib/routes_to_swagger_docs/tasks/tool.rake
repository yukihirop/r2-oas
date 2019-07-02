# frozen_string_literal: true

require_relative '../schema/generator'
require_relative '../deploy/client'
require_relative '../tool/paths/ls'
require_relative '../tool/paths/stats'
require_relative '../task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :swagger do
    desc 'Deploy Swagger UI'
    task deploy: [:common] do
      logger.info '[Routes to Swagger docs] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_schemas: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      client_options = {}
      client = RoutesToSwaggerDocs::Deploy::Client.new(client_options)
      client.deploy

      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Display paths list'
    task paths_ls: [:common] do
      fd = IO.sysopen('/dev/null', 'w+')
      $stdout = IO.new(fd)
      logger.level = :null
      logger.info '[Routes to Swagger docs] start'
      $stdout = StringIO.new

      paths_ls_options = {}
      paths_ls = RoutesToSwaggerDocs::Tool::Paths::Ls.new(paths_ls_options)
      paths_ls.print

      logger.info '[Routes to Swagger docs] end'

      result = $stdout.string
      $stdout = STDOUT
      puts result
    end

    desc 'Display paths stats'
    task paths_stats: [:common] do
      fd = IO.sysopen('/dev/null', 'w+')
      $stdout = IO.new(fd)
      logger.level = :null

      logger.info '[Routes to Swagger docs] start'
      generator_options = { skip_generate_schemas: true, skip_load_dot_paths: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, generator_options)
      generator.generate_docs

      $stdout = StringIO.new

      paths_log_options = {}
      paths_log = RoutesToSwaggerDocs::Tool::Paths::Stats.new(paths_log_options)
      paths_log.print

      logger.info '[Routes to Swagger docs] end'

      result = $stdout.string
      $stdout = STDOUT
      puts result
    end

    private

    def unit_paths_file_path
      ENV.fetch('UNIT_PATHS_FILE_PATH', '')
    end

    def existing_schema_file_path
      ENV.fetch('SWAGGER_FILE', '')
    end
  end
end
