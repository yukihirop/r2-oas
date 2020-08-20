# frozen_string_literal: true

require 'r2-oas/schema/editor'
require 'r2-oas/schema/ui'
require 'r2-oas/schema/monitor'
require 'r2-oas/deploy/client'
require 'r2-oas/task_logging'
load File.expand_path('common.rake', __dir__)

namespace :routes do
  namespace :oas do
    desc '[R2-OAS] Initialize'
    task init: [:common] do
      R2OAS.init
      puts '[R2-OAS] Initialized!'
    end

    desc '[R2-OAS] Generate OAS documentation files'
    task docs: [:common] do
      start do
        is_create_cache = cache_docs.eql? 'true'
        options = { unit_paths_file_path: unit_paths_file_path, skip_load_dot_paths: true, is_create_cache: is_create_cache }
        generator = R2OAS::Schema::Generator.new(options)
        generator.generate_docs
      end
    end

    desc '[R2-OAS] Analyze OAS documentation'
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

    desc '[R2-OAS] Build OAS documentation'
    task build: [:common] do
      start do
        output_dir_path = File.expand_path(R2OAS.output_dir_path)
        FileUtils.mkdir_p(output_dir_path) unless FileTest.exists?(output_dir_path)

        is_overrirde_src = override_src.eql? 'true'
        use_plugin = skip_plugin.eql? 'false'
        builder_options = { unit_paths_file_path: unit_paths_file_path, use_plugin: use_plugin, output: true }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        if is_overrirde_src
          before_schama_data = builder.pure_oas_doc
          after_schema_data = builder.oas_doc
          analyzer_options = { type: :edited }
          analyzer = R2OAS::Schema::Analyzer.new(before_schama_data, after_schema_data, analyzer_options)
          analyzer.analyze_docs
        end
      end
    end

    desc '[R2-OAS] Open Swagger Editor'
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

    desc '[R2-OAS] Open Swagger UI'
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

    desc '[R2-OAS] Monitor OAS Document'
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

    desc '[R2-OAS] Clean OAS Document'
    task clean: [:common] do
      start do
        builder_options = { skip_load_dot_paths: true }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        cleaner = R2OAS::Schema::Cleaner.new
        cleaner.clean_docs
      end
    end

    desc '[R2-OAS] Deploy OAS Document'
    task deploy: [:common] do
      start do
        client_options = {}
        client = R2OAS::Deploy::Client.new(client_options)

        download_dist_th = Thread.new do
          puts 'Download swagger-api/swagger-ui/dist ... (async)'
          client.download_swagger_ui_dist
        end

        output_dir_path = File.expand_path(R2OAS.output_dir_path)
        FileUtils.mkdir_p(output_dir_path) unless FileTest.exists?(output_dir_path)

        builder_options = { unit_paths_file_path: unit_paths_file_path, use_plugin: true, output: true }
        builder = R2OAS::Schema::Builder.new(builder_options)
        builder.build_docs

        download_dist_th.join
        client.deploy
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

    def override_src
      ENV.fetch('OVERRIDE_SRC', 'false')
    end

    def skip_plugin
      ENV.fetch('SKIP_PLUGIN', 'false')
    end
  end
end
