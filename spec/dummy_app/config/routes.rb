DummyApp::Application.routes.draw do
  resources :tasks

  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
end
