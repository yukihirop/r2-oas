module RoutesToSwaggerDocs
  class Task < ::Rails::Railtie
    rake_tasks do
      task_path = File.join(File.dirname(__FILE__), './tasks/swagger.rake')
      Dir[task_path].each{ |f| load f }
    end
  end
end