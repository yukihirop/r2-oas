# frozen_string_literal: true

require 'routes_to_swagger_docs/schema/editor'
require 'routes_to_swagger_docs/schema/ui'
require 'routes_to_swagger_docs/schema/monitor'
require 'routes_to_swagger_docs/task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :swagger do
    desc 'Generate Swagger documentation files'
    task docs: [:common] do
      logger.info '[Routes to Swagger docs] start'
      options = { unit_paths_file_path: unit_paths_file_path, skip_load_dot_paths: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(options)
      generator.generate_docs
      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Analyze Swagger documentation'
    task analyze: [:common] do
      logger.info '[Routes to Swagger docs] start'

      analyzer_options = { type: :existing, existing_schema_file_path: existing_schema_file_path }
      analyzer = RoutesToSwaggerDocs::Schema::Analyzer.new({}, {}, analyzer_options)
      analyzer.analyze_docs

      generator_options = { skip_generate_docs: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Open Swagger Editor'
    task editor: [:common] do
      logger.info '[Routes to Swagger docs] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      before_schema_data = generator.swagger_doc
      editor_options = { unit_paths_file_path: unit_paths_file_path }
      editor = RoutesToSwaggerDocs::Schema::Editor.new(before_schema_data, editor_options)
      editor.start

      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Open Swagger UI'
    task ui: [:common] do
      logger.info '[Routes to Swagger docs] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      ui_options = { unit_paths_file_path: unit_paths_file_path }
      ui = RoutesToSwaggerDocs::Schema::UI.new(ui_options)
      ui.start

      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Monitor Swagger Document'
    task monitor: [:common] do
      logger.info '[Routes to Swagger docs] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      before_schema_data = generator.swagger_doc
      monitor_options = { unit_paths_file_path: unit_paths_file_path }
      monitor = RoutesToSwaggerDocs::Schema::Monitor.new(before_schema_data, monitor_options)
      monitor.start

      logger.info '[Routes to Swagger docs] end'
    end

    desc 'Clean Swagger Document'
    task clean: [:common] do
      logger.info '[Routes to Swagger docs] start'

      generator_options = { skip_generate_docs: true, skip_load_dot_paths: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new(generator_options)
      generator.generate_docs

      cleaner = RoutesToSwaggerDocs::Schema::Cleaner.new
      cleaner.clean_docs

      logger.info '[Routes to Swagger docs] end'
    end

    private

    def unit_paths_file_path
      ENV.fetch('PATHS_FILE', '')
    end

    def existing_schema_file_path
      ENV.fetch('SWAGGER_FILE', '')
    end
  end
end
