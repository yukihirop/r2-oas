# frozen_string_literal: true

module R2OAS
  class Task < ::Rails::Railtie
    rake_tasks do
      main_task_path = File.join(File.dirname(__FILE__), './tasks/main.rake')
      Dir[main_task_path].each { |f| load f }
    end
  end
end
