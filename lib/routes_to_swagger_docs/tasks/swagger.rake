require_relative '../client'

namespace :routes do
  namespace :swagger do
    desc "Generate Swagger documentation files"
    task :docs => [:environment] do
      client.generate_docs
    end

    private

    def client
      RoutesToSwaggerDocs::Client.new
    end
  end
end