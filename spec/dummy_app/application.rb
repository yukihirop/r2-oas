require 'active_record'
require 'action_controller/railtie'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

module DummyApp
  class Application < Rails::Application
    config.secret_token = "209c94433ee5bf2a2b086bd51a7b6a5d15487d3353f438418e0c71d0fe534ea717777f3ca9655c0b2865206703a2ab61dcd1384341b1f94ca54b5fffb6987f3d"
    config.session_store :cookie_store, key: "_dummy_session"
    config.active_support.deprecation = :log
    config.eager_load = false
    config.action_dispatch.show_exceptions = false
    config.root = File.dirname(__FILE__)

    RoutesToSwaggerDocs.configure do |c|
      c.root_dir_path = "#{config.root}/swagger_docs"
    end
  end
end

DummyApp::Application.initialize!

# routes
require_relative 'config/routes'

# models
require_relative 'models/application_record'
require_relative 'models/task'
require_relative 'models/api/v1/task'

# controllers
require_relative 'controllers/application_controller'
require_relative 'controllers/tasks_controller'
require_relative 'controllers/api/v1/tasks_controller'

# migrations
require_relative 'db/migrate/01_create_tasks'
require_relative 'db/migrate/02_create_api_v1_tasks'
