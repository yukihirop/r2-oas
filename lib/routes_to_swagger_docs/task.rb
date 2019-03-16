module RoutesToSwaggerDocs
  class Task < ::Rails::Railtie
    rake_tasks do
      task_regex_path = File.join(File.dirname(__FILE__), './tasks/*.rake')
      Dir[task_regex_path].each{ |f| load f }
    end
  end
end