# frozen_string_literal: true

require 'r2-oas/schema/editor'
require 'r2-oas/schema/ui'
require 'r2-oas/schema/monitor'
require 'r2-oas/task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :oas do
    desc 'Generate Swagger documentation files'
    task docs: [:common] do
      logger.info '[R2-OAS] start'
      options = { unit_paths_file_path: unit_paths_file_path, skip_load_dot_paths: true }
      generator = R2OAS::Schema::Generator.new(options)
      generator.generate_docs
      logger.info '[R2-OAS] end'
    end

    desc 'Analyze Swagger documentation'
    task analyze: [:common] do
      logger.info '[R2-OAS] start'

      analyzer_options = { type: :existing, existing_schema_file_path: existing_schema_file_path }
      analyzer = R2OAS::Schema::Analyzer.new({}, {}, analyzer_options)
      analyzer.analyze_docs

      generator_options = { skip_generate_docs: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      logger.info '[R2-OAS] end'
    end

    desc 'Distribute Swagger documentation'
    task dist: [:common] do
      logger.info '[R2-OAS] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      logger.info '[R2-OAS] end'
    end

    desc 'Open Swagger Editor'
    task editor: [:common] do
      logger.info '[R2-OAS] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      before_schema_data = generator.oas_doc
      editor_options = { unit_paths_file_path: unit_paths_file_path }
      editor = R2OAS::Schema::Editor.new(before_schema_data, editor_options)
      editor.start

      logger.info '[R2-OAS] end'
    end

    desc 'Open Swagger UI'
    task ui: [:common] do
      logger.info '[R2-OAS] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      ui_options = { unit_paths_file_path: unit_paths_file_path }
      ui = R2OAS::Schema::UI.new(ui_options)
      ui.start

      logger.info '[R2-OAS] end'
    end

    desc 'Monitor Swagger Document'
    task monitor: [:common] do
      logger.info '[R2-OAS] start'

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_docs: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      before_schema_data = generator.oas_doc
      monitor_options = { unit_paths_file_path: unit_paths_file_path }
      monitor = R2OAS::Schema::Monitor.new(before_schema_data, monitor_options)
      monitor.start

      logger.info '[R2-OAS] end'
    end

    desc 'Clean Swagger Document'
    task clean: [:common] do
      logger.info '[R2-OAS] start'

      generator_options = { skip_generate_docs: true, skip_load_dot_paths: true }
      generator = R2OAS::Schema::Generator.new(generator_options)
      generator.generate_docs

      cleaner = R2OAS::Schema::Cleaner.new
      cleaner.clean_docs

      logger.info '[R2-OAS] end'
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
