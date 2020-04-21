# Monitor docs

## Prepare

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

## Command

```bash
$ bundle exec rake routes:oas:monitor
```

## Example

if there is routing like this:

```
$ bundle exec  rake routes
                       Prefix Verb   URI Pattern                                           Controller#Action
    api_v1_account_user_roles GET    /api/v1/account_user_roles(.:format)                  api/v1/account_user_roles#index
 new_api_v1_account_user_role GET    /api/v1/account_user_roles/new(.:format)              api/v1/account_user_roles#new
edit_api_v1_account_user_role GET    /api/v1/account_user_roles/:id/edit(.:format)         api/v1/account_user_roles#edit
     api_v1_account_user_role GET    /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#show
                              PATCH  /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#update
                              PUT    /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#update
                              DELETE /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#destroy
                       api_v1 POST   /api/v1/accounts/:account_id/users(.:format)          api/v1/account_user_role#create
         api_v1_account_users GET    /api/v1/accounts/:account_id/users(.:format)          api/v1/users#index
      new_api_v1_account_user GET    /api/v1/accounts/:account_id/users/new(.:format)      api/v1/users#new
     edit_api_v1_account_user GET    /api/v1/accounts/:account_id/users/:id/edit(.:format) api/v1/users#edit
          api_v1_account_user GET    /api/v1/accounts/:account_id/users/:id(.:format)      api/v1/users#show
                              PATCH  /api/v1/accounts/:account_id/users/:id(.:format)      api/v1/users#update
                              PUT    /api/v1/accounts/:account_id/users/:id(.:format)      api/v1/users#update
                              DELETE /api/v1/accounts/:account_id/users/:id(.:format)      api/v1/users#destroy
              api_v1_accounts GET    /api/v1/accounts(.:format)                            api/v1/accounts#index
                              POST   /api/v1/accounts(.:format)                            api/v1/accounts#create
           new_api_v1_account GET    /api/v1/accounts/new(.:format)                        api/v1/accounts#new
          edit_api_v1_account GET    /api/v1/accounts/:id/edit(.:format)                   api/v1/accounts#edit
               api_v1_account GET    /api/v1/accounts/:id(.:format)                        api/v1/accounts#show
                              PATCH  /api/v1/accounts/:id(.:format)                        api/v1/accounts#update
                              PUT    /api/v1/accounts/:id(.:format)                        api/v1/accounts#update
                              DELETE /api/v1/accounts/:id(.:format)                        api/v1/accounts#destroy
                              GET    /api/v1/account_user_roles(.:format)                  api/v1/account_user_roles#index
                              POST   /api/v1/account_user_roles(.:format)                  api/v1/account_user_roles#create
                              GET    /api/v1/account_user_roles/new(.:format)              api/v1/account_user_roles#new
                              GET    /api/v1/account_user_roles/:id/edit(.:format)         api/v1/account_user_roles#edit
                              GET    /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#show
                              PATCH  /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#update
                              PUT    /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#update
                              DELETE /api/v1/account_user_roles/:id(.:format)              api/v1/account_user_roles#destroy
                 api_v1_users GET    /api/v1/users(.:format)                               api/v1/users#index
                              POST   /api/v1/users(.:format)                               api/v1/users#create
              new_api_v1_user GET    /api/v1/users/new(.:format)                           api/v1/users#new
             edit_api_v1_user GET    /api/v1/users/:id/edit(.:format)                      api/v1/users#edit
                  api_v1_user GET    /api/v1/users/:id(.:format)                           api/v1/users#show
                              PATCH  /api/v1/users/:id(.:format)                           api/v1/users#update
                              PUT    /api/v1/users/:id(.:format)                           api/v1/users#update
                              DELETE /api/v1/users/:id(.:format)                           api/v1/users#destroy
                              GET    /api/v1/accounts(.:format)                            api/v1/accounts#index
                              POST   /api/v1/accounts(.:format)                            api/v1/accounts#create
                              GET    /api/v1/accounts/new(.:format)                        api/v1/accounts#new
                              GET    /api/v1/accounts/:id/edit(.:format)                   api/v1/accounts#edit
                              GET    /api/v1/accounts/:id(.:format)                        api/v1/accounts#show
                              PATCH  /api/v1/accounts/:id(.:format)                        api/v1/accounts#update
                              PUT    /api/v1/accounts/:id(.:format)                        api/v1/accounts#update
                              DELETE /api/v1/accounts/:id(.:format)                        api/v1/accounts#destroy
          api_v2_custom_posts GET    /api/v2/custom_posts(.:format)                        api/v2/custom_posts#index
                              POST   /api/v2/custom_posts(.:format)                        api/v2/custom_posts#create
       new_api_v2_custom_post GET    /api/v2/custom_posts/new(.:format)                    api/v2/custom_posts#new
      edit_api_v2_custom_post GET    /api/v2/custom_posts/:id/edit(.:format)               api/v2/custom_posts#edit
           api_v2_custom_post GET    /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#show
                              PATCH  /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#update
                              PUT    /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#update
                              DELETE /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#destroy
               rails_subadmin        /subadmin                                             RailsAdmin::Engine
                  rails_admin        /admin                                                RailsAdmin::Engine
                 api_v2_posts GET    /api/v2/posts(.:format)                               api/v2/posts#index {:format=>:json}
             edit_api_v2_post GET    /api/v2/posts/:id/edit(.:format)                      api/v2/posts#edit {:format=>:json}
                  api_v2_post GET    /api/v2/posts/:id(.:format)                           api/v2/posts#show {:format=>:json}
                              PATCH  /api/v2/posts/:id(.:format)                           api/v2/posts#update {:format=>:json}
                              PUT    /api/v2/posts/:id(.:format)                           api/v2/posts#update {:format=>:json}
                              GET    /api/v2/custom_posts(.:format)                        api/v2/custom_posts#index {:format=>:json}
                              GET    /api/v2/custom_posts/:id/edit(.:format)               api/v2/custom_posts#edit {:format=>:json}
                              GET    /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#show {:format=>:json}
                              PATCH  /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#update {:format=>:json}
                              PUT    /api/v2/custom_posts/:id(.:format)                    api/v2/custom_posts#update {:format=>:json}
                              POST   /api/v2/posts(.:format)                               api/v2/custom_posts#create {:format=>:json}
                 api_v1_posts GET    /api/v1/posts(.:format)                               api/v1/posts#index
                              POST   /api/v1/posts(.:format)                               api/v1/posts#create
              new_api_v1_post GET    /api/v1/posts/new(.:format)                           api/v1/posts#new
             edit_api_v1_post GET    /api/v1/posts/:id/edit(.:format)                      api/v1/posts#edit
                  api_v1_post GET    /api/v1/posts/:id(.:format)                           api/v1/posts#show
                              PATCH  /api/v1/posts/:id(.:format)                           api/v1/posts#update
                              PUT    /api/v1/posts/:id(.:format)                           api/v1/posts#update
                              DELETE /api/v1/posts/:id(.:format)                           api/v1/posts#destroy
                 api_v1_tasks GET    /api/v1/tasks(.:format)                               api/v1/tasks#index
                              POST   /api/v1/tasks(.:format)                               api/v1/tasks#create
              new_api_v1_task GET    /api/v1/tasks/new(.:format)                           api/v1/tasks#new
             edit_api_v1_task GET    /api/v1/tasks/:id/edit(.:format)                      api/v1/tasks#edit
                  api_v1_task GET    /api/v1/tasks/:id(.:format)                           api/v1/tasks#show
                              PATCH  /api/v1/tasks/:id(.:format)                           api/v1/tasks#update
                              PUT    /api/v1/tasks/:id(.:format)                           api/v1/tasks#update
                              DELETE /api/v1/tasks/:id(.:format)                           api/v1/tasks#destroy
                        tasks GET    /tasks(.:format)                                      tasks#index
                              POST   /tasks(.:format)                                      tasks#create
                     new_task GET    /tasks/new(.:format)                                  tasks#new
                    edit_task GET    /tasks/:id/edit(.:format)                             tasks#edit
                         task GET    /tasks/:id(.:format)                                  tasks#show
                              PATCH  /tasks/:id(.:format)                                  tasks#update
                              PUT    /tasks/:id(.:format)                                  tasks#update
                              DELETE /tasks/:id(.:format)                                  tasks#destroy
                        users GET    /users(.:format)                                      users#index
                              POST   /users(.:format)                                      users#create
                     new_user GET    /users/new(.:format)                                  users#new
                    edit_user GET    /users/:id/edit(.:format)                             users#edit
                         user GET    /users/:id(.:format)                                  users#show
                              PATCH  /users/:id(.:format)                                  users#update
                              PUT    /users/:id(.:format)                                  users#update
                              DELETE /users/:id(.:format)                                  users#destroy

Routes for RailsAdmin::Engine:
  dashboard GET         /                                      rails_admin/main#dashboard
      index GET|POST    /:model_name(.:format)                 rails_admin/main#index
        new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
     export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
       show GET         /:model_name/:id(.:format)             rails_admin/main#show
       edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
     delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
```

#### VS Code

If you use [Swagger Viewer](https://marketplace.visualstudio.com/items?itemName=Arjun.swagger-viewer)

<img alt="swagger_editor" src="https://user-images.githubusercontent.com/11146767/60355006-75e70100-9a08-11e9-9f52-dfacb681791e.png" width="546">

```
I, [2019-06-29T00:52:29.568306 #16277]  INFO -- : [R2-OAS] start
I, [2019-06-29T00:52:29.857556 #16277]  INFO -- : [Generate Swagger schema files] start
I, [2019-06-29T00:52:29.857599 #16277]  INFO -- : [Generate Swagger schema files] end
I, [2019-06-29T00:52:29.857609 #16277]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-06-29T00:52:29.858201 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/openapi.yml
I, [2019-06-29T00:52:29.859837 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/user.yml
I, [2019-06-29T00:52:29.861592 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account_user_role.yml
I, [2019-06-29T00:52:29.865069 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/user.yml
I, [2019-06-29T00:52:29.866911 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account.yml
I, [2019-06-29T00:52:29.868569 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/task.yml
I, [2019-06-29T00:52:29.869994 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/post.yml
I, [2019-06-29T00:52:29.871558 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/custom_post.yml
I, [2019-06-29T00:52:29.872561 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/post.yml
I, [2019-06-29T00:52:29.873925 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/task.yml
I, [2019-06-29T00:52:29.874329 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/engine.yml
I, [2019-06-29T00:52:29.877551 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/main.yml
I, [2019-06-29T00:52:29.877670 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/externalDocs.yml
I, [2019-06-29T00:52:29.878309 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/tags.yml
I, [2019-06-29T00:52:29.878477 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/account_user_role.yml
I, [2019-06-29T00:52:29.878635 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/custom_post.yml
I, [2019-06-29T00:52:29.878778 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user/new/200/get.yml
I, [2019-06-29T00:52:29.878955 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user.yml
I, [2019-06-29T00:52:29.879127 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/account.yml
I, [2019-06-29T00:52:29.879270 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/task.yml
I, [2019-06-29T00:52:29.879441 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/engine.yml
I, [2019-06-29T00:52:29.879621 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/main.yml
I, [2019-06-29T00:52:29.879767 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/post.yml
I, [2019-06-29T00:52:29.879960 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/info.yml
I, [2019-06-29T00:52:29.880072 #16277]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/servers.yml
I, [2019-06-29T00:52:29.926654 #16277]  INFO -- : [Generate Swagger docs from schema files] end

wait for single trap ...
```

When you press `Ctrl + C` after edit schema ,

```
^C
^CI, [2019-06-29T00:55:38.492337 #16277]  INFO -- : [Analyze Swagger file] start
I, [2019-06-29T00:55:38.494113 #16277]  INFO -- : [Analyze Swagger file (paths)] start
I, [2019-06-29T00:55:38.503677 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/main.yml
I, [2019-06-29T00:55:38.504894 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/engine.yml
I, [2019-06-29T00:55:38.509686 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account_user_role.yml
I, [2019-06-29T00:55:38.522787 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account.yml
I, [2019-06-29T00:55:38.532995 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/user.yml
I, [2019-06-29T00:55:38.537879 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/post.yml
I, [2019-06-29T00:55:38.542680 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/task.yml
I, [2019-06-29T00:55:38.548333 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/custom_post.yml
I, [2019-06-29T00:55:38.552802 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/post.yml
I, [2019-06-29T00:55:38.560056 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/task.yml
I, [2019-06-29T00:55:38.566850 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/user.yml
I, [2019-06-29T00:55:38.566886 #16277]  INFO -- : [Analyze Swagger file (paths)] end
I, [2019-06-29T00:55:38.567852 #16277]  INFO -- : [Analyze Swagger file (tags)] start
I, [2019-06-29T00:55:38.569655 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/tags.yml
I, [2019-06-29T00:55:38.569691 #16277]  INFO -- : [Analyze Swagger file (tags)] end
I, [2019-06-29T00:55:38.569708 #16277]  INFO -- : [Analyze Swagger file (components)] start
I, [2019-06-29T00:55:38.569724 #16277]  INFO -- : [Analyze Swagger file (components/schemas)] start
I, [2019-06-29T00:55:38.570894 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/account.yml
I, [2019-06-29T00:55:38.571540 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/account_user_role.yml
I, [2019-06-29T00:55:38.572217 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/custom_post.yml
I, [2019-06-29T00:55:38.573028 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/engine.yml
I, [2019-06-29T00:55:38.573710 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/main.yml
I, [2019-06-29T00:55:38.574328 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/post.yml
I, [2019-06-29T00:55:38.575088 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/task.yml
I, [2019-06-29T00:55:38.575687 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user.yml
I, [2019-06-29T00:55:38.576485 #16277]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user/new/200/get.yml
I, [2019-06-29T00:55:38.576518 #16277]  INFO -- : [Analyze Swagger file (components/schemas)] end
I, [2019-06-29T00:55:38.576535 #16277]  INFO -- : [Analyze Swagger file (components/requestBodies)] start
I, [2019-06-29T00:55:38.576852 #16277]  INFO -- : [Analyze Swagger file (components/requestBodies)] end
I, [2019-06-29T00:55:38.576867 #16277]  INFO -- : [Analyze Swagger file (components)] end
I, [2019-06-29T00:55:38.580873 #16277]  INFO -- : [Analyze Swagger file] end
I, [2019-06-29T00:55:38.587586 #16277]  INFO -- : [R2-OAS] end
```
