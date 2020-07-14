# frozen_string_literal: true

require 'r2-oas/task_logging'

namespace :routes do
  namespace :oas do
    extend R2OAS::TaskLogging

    # private
    # desc "Setup a common setting for every tasks"
    task common: [:environment] do
      create_dot_paths
    end

    # private
    # desc "Switch the level of a logger to DEBUG"
    task debug: [:common] do
      set_debug_level
    end

    def create_dot_paths
      R2OAS.paths_config.create_dot_paths
    end
  end
end
