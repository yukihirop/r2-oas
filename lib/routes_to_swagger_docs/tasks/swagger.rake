require_relative '../generator'
require_relative '../task_logging'
load  File.expand_path('../common.rake', __FILE__)

namespace :routes do
  namespace :swagger do
    desc "Generate Swagger documentation files"
    task :docs => [:common] do
      logger.info "[Routes to Swagger docs] start"
      generator.generate_docs
      logger.info "[Routes to Swagger docs] end"
    end

    private

    def generator
      RoutesToSwaggerDocs::Generator.new
    end
  end
end