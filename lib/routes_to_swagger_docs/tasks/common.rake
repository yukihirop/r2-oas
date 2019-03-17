require_relative '../task_logging'

namespace :routes do
  namespace :swagger do
    extend RoutesToSwaggerDocs::TaskLogging

    # private
    # desc "Setup a common setting for every tasks"
    task :common => [:environment] do
      set_info_level
    end

    # private
    # desc "Switch the level of a logger to DEBUG"
    task :debug => [:common] do
      set_debug_level
    end
  end
end