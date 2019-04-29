require_relative '../schema/generator'
require_relative '../schema/editor'
require_relative '../schema/ui'
require_relative '../task_logging'
load  File.expand_path('../common.rake', __FILE__)

namespace :routes do
  namespace :swagger do
    desc "Generate Swagger documentation files"
    task :docs => [:common] do
      logger.info "[Routes to Swagger docs] start"
      generator = RoutesToSwaggerDocs::Schema::Generator.new({}, options)
      generator.generate_docs
      logger.info "[Routes to Swagger docs] end"
    end

    desc "Open Swagger Editor"
    task :editor => [:common] do
      logger.info "[Routes to Swagger docs] start"
      Rake::Task["routes:swagger:docs"].invoke
      editor = RoutesToSwaggerDocs::Schema::Editor.new({}, options)
      editor.start
      logger.info "[Routes to Swagger docs] end"
    end

    desc "Open Swagger UI"
    task :ui => [:common] do
      logger.info "[Routes to Swagger docs] start"
      Rake::Task["routes:swagger:docs"].invoke
      ui = RoutesToSwaggerDocs::Schema::UI.new({}, options)
      ui.start
      logger.info "[Routes to Swagger docs] end"
    end

    private

    def unit_paths_file_path
      ENV.fetch("UNIT_PATHS_FILE_PATH","")
    end

    def options
      { unit_paths_file_path: unit_paths_file_path }
    end
  end
end