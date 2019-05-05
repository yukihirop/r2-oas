require_relative '../schema/generator'
require_relative '../schema/editor'
require_relative '../schema/ui'
require_relative '../schema/analyzer'
require_relative '../task_logging'
load  File.expand_path('../common.rake', __FILE__)

namespace :routes do
  namespace :swagger do
    desc "Generate Swagger documentation files"
    task :docs => [:common] do
      logger.info "[Routes to Swagger docs] start"
      options = { unit_paths_file_path: unit_paths_file_path }
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, options)
      generator.generate_docs
      logger.info "[Routes to Swagger docs] end"
    end

    desc "Analyze existing Swagger documentation"
    task :analyze => [:common] do
      logger.info "[Routes to Swagger docs] start"

      analyzer_options = { type: :existing, existing_schema_file_path: existing_schema_file_path }
      analyzer = RoutesToSwaggerDocs::Schema::Analyzer.new({}, analyzer_options)
      analyzer.update_from_schema

      generator_options = { skip_generate_schemas: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, generator_options)
      generator.generate_docs

      logger.info "[Routes to Swagger docs] end"
    end

    desc "Open Swagger Editor"
    task :editor => [:common] do
      logger.info "[Routes to Swagger docs] start"

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_schemas: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, generator_options)
      generator.generate_docs

      editor_options = { unit_paths_file_path: unit_paths_file_path }
      editor = RoutesToSwaggerDocs::Schema::Editor.new({}, editor_options)
      editor.start

      logger.info "[Routes to Swagger docs] end"
    end

    desc "Open Swagger UI"
    task :ui => [:common] do
      logger.info "[Routes to Swagger docs] start"

      generator_options = { unit_paths_file_path: unit_paths_file_path, skip_generate_schemas: true }
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, generator_options)
      generator.generate_docs

      ui_options = { unit_paths_file_path: unit_paths_file_path }
      ui = RoutesToSwaggerDocs::Schema::UI.new({}, ui_options)
      ui.start
      
      logger.info "[Routes to Swagger docs] end"
    end

    private

    def unit_paths_file_path
      ENV.fetch("UNIT_PATHS_FILE_PATH","")
    end

    def existing_schema_file_path
      ENV.fetch("SWAGGER_FILE","")
    end
  end
end