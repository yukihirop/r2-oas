# frozen_string_literal: true

require 'r2-oas/schema/editor'
require 'r2-oas/schema/ui'
require 'r2-oas/schema/monitor'
require 'r2-oas/task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :oas do
    desc 'Generate OAS documentation files'
    task docs: [:common] do
      start do
        is_create_cache = cache_docs === 'true'
        options = { unit_paths_file_path: unit_paths_file_path, skip_load_dot_paths: true, is_create_cache: is_create_cache }
        generator = R2OAS::Schema::Generator.new(options)
        generator.generate_docs
      end
    end

    desc 'Analyze OAS documentation'
    task analyze: [:common] do
      start do
        analyzer_options = { type: :existing, existing_schema_file_path: existing_schema_file_path }
        analyzer = R2OAS::Schema::Analyzer.new({}, {}, analyzer_options)
        analyzer.analyze_docs

        builder_options = {}
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs
      end
    end

    desc 'Distribute OAS documentation'
    task dist: [:common] do
      start do
        builder_options = { unit_paths_file_path: unit_paths_file_path }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs
      end
    end

    desc 'Open Swagger Editor'
    task editor: [:common] do
      start do
        builder_options = { unit_paths_file_path: unit_paths_file_path }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        before_schema_data = builder.oas_doc
        editor_options = { unit_paths_file_path: unit_paths_file_path }
        editor = R2OAS::Schema::Editor.new(before_schema_data, editor_options)
        editor.start
      end
    end

    desc 'Open Swagger UI'
    task ui: [:common] do
      start do
        builder_options = { unit_paths_file_path: unit_paths_file_path }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        ui_options = { unit_paths_file_path: unit_paths_file_path }
        ui = R2OAS::Schema::UI.new(ui_options)
        ui.start
      end
    end

    desc 'Monitor OAS Document'
    task monitor: [:common] do
      start do
        builder_options = { unit_paths_file_path: unit_paths_file_path }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        before_schema_data = builder.oas_doc
        monitor_options = { unit_paths_file_path: unit_paths_file_path }
        monitor = R2OAS::Schema::Monitor.new(before_schema_data, monitor_options)
        monitor.start
      end
    end

    desc 'Clean OAS Document'
    task clean: [:common] do
      start do
        builder_options = { skip_load_dot_paths: true }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        cleaner = R2OAS::Schema::Cleaner.new
        cleaner.clean_docs
      end
    end

    private

    def unit_paths_file_path
      ENV.fetch('PATHS_FILE', '')
    end

    def existing_schema_file_path
      ENV.fetch('OAS_FILE', '')
    end

    def cache_docs
      ENV.fetch('CACHE_DOCS', 'false')
    end
  end
end
