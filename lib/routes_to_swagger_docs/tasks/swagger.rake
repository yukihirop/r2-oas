require_relative '../generator'

namespace :routes do
  namespace :swagger do
    desc "Generate Swagger documentation files"
    task :docs => [:environment] do
      generator.generate_docs
    end

    private

    def generator
      RoutesToSwaggerDocs::Generator.new
    end
  end
end