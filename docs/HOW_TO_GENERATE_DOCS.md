## Basic Usage

```ruby

require 'routes_to_swagger_docs'

RoutesToSwaggerDocs.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
end
```

```bash
$ bundle exec rake routes:swagger:docs
```

## Example

if there is routing like this:

```
$ bundle exec  rake routes
          Prefix Verb   URI Pattern                      Controller#Action
     rails_admin        /admin                           RailsAdmin::Engine
    api_v2_posts GET    /api/v2/posts(.:format)          api/v2/posts#index {:format=>:json}
                 POST   /api/v2/posts(.:format)          api/v2/posts#create {:format=>:json}
 new_api_v2_post GET    /api/v2/posts/new(.:format)      api/v2/posts#new {:format=>:json}
edit_api_v2_post GET    /api/v2/posts/:id/edit(.:format) api/v2/posts#edit {:format=>:json}
     api_v2_post GET    /api/v2/posts/:id(.:format)      api/v2/posts#show {:format=>:json}
                 PATCH  /api/v2/posts/:id(.:format)      api/v2/posts#update {:format=>:json}
                 PUT    /api/v2/posts/:id(.:format)      api/v2/posts#update {:format=>:json}
                 DELETE /api/v2/posts/:id(.:format)      api/v2/posts#destroy {:format=>:json}
    api_v1_posts GET    /api/v1/posts(.:format)          api/v1/posts#index
                 POST   /api/v1/posts(.:format)          api/v1/posts#create
 new_api_v1_post GET    /api/v1/posts/new(.:format)      api/v1/posts#new
edit_api_v1_post GET    /api/v1/posts/:id/edit(.:format) api/v1/posts#edit
     api_v1_post GET    /api/v1/posts/:id(.:format)      api/v1/posts#show
                 PATCH  /api/v1/posts/:id(.:format)      api/v1/posts#update
                 PUT    /api/v1/posts/:id(.:format)      api/v1/posts#update
                 DELETE /api/v1/posts/:id(.:format)      api/v1/posts#destroy
    api_v1_tasks GET    /api/v1/tasks(.:format)          api/v1/tasks#index
                 POST   /api/v1/tasks(.:format)          api/v1/tasks#create
 new_api_v1_task GET    /api/v1/tasks/new(.:format)      api/v1/tasks#new
edit_api_v1_task GET    /api/v1/tasks/:id/edit(.:format) api/v1/tasks#edit
     api_v1_task GET    /api/v1/tasks/:id(.:format)      api/v1/tasks#show
                 PATCH  /api/v1/tasks/:id(.:format)      api/v1/tasks#update
                 PUT    /api/v1/tasks/:id(.:format)      api/v1/tasks#update
                 DELETE /api/v1/tasks/:id(.:format)      api/v1/tasks#destroy
           tasks GET    /tasks(.:format)                 tasks#index
                 POST   /tasks(.:format)                 tasks#create
        new_task GET    /tasks/new(.:format)             tasks#new
       edit_task GET    /tasks/:id/edit(.:format)        tasks#edit
            task GET    /tasks/:id(.:format)             tasks#show
                 PATCH  /tasks/:id(.:format)             tasks#update
                 PUT    /tasks/:id(.:format)             tasks#update
                 DELETE /tasks/:id(.:format)             tasks#destroy
           users GET    /users(.:format)                 users#index
                 POST   /users(.:format)                 users#create
        new_user GET    /users/new(.:format)             users#new
       edit_user GET    /users/:id/edit(.:format)        users#edit
            user GET    /users/:id(.:format)             users#show
                 PATCH  /users/:id(.:format)             users#update
                 PUT    /users/:id(.:format)             users#update
                 DELETE /users/:id(.:format)             users#destroy

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

#### First try

```
$ bundle exec rake routes:swagger:docs
I, [2019-03-17T16:54:22.141619 #46769]  INFO -- : [Routes to Swagger docs] start
I, [2019-03-17T16:54:22.180295 #46769]  INFO -- : [Generate Swagger schema files] start
I, [2019-03-17T16:54:22.201397 #46769]  INFO -- : <From routes data>
I, [2019-03-17T16:54:22.202094 #46769]  INFO -- : <Update schema files>
I, [2019-03-17T16:54:22.222877 #46769]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-03-17T16:54:22.223625 #46769]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-03-17T16:54:22.226086 #46769]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-03-17T16:54:22.226130 #46769]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-03-17T16:54:22.260274 #46769]  INFO -- :  <From routes data>
I, [2019-03-17T16:54:22.260478 #46769]  INFO -- :  <Update schema files (paths)>
I, [2019-03-17T16:54:22.261223 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:22.263575 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:22.264573 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:22.265477 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:22.266426 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:22.267318 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:22.269068 #46769]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:22.269091 #46769]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-03-17T16:54:22.269351 #46769]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-03-17T16:54:22.269645 #46769]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-03-17T16:54:22.269667 #46769]  INFO -- : [Generate Swagger schema files] end
I, [2019-03-17T16:54:22.269678 #46769]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-03-17T16:54:22.270080 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-03-17T16:54:22.270477 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:22.270870 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:22.271238 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:22.271700 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:22.272125 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:22.272329 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:22.272953 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:22.273071 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-03-17T16:54:22.273414 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-03-17T16:54:22.273598 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-03-17T16:54:22.273724 #46769]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-03-17T16:54:22.279880 #46769]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-03-17T16:54:22.279916 #46769]  INFO -- : [Routes to Swagger docs] end
```

#### Second try

```
$ bundle exec rake routes:swagger:docs
I, [2019-03-17T16:54:49.460842 #46856]  INFO -- : [Routes to Swagger docs] start
I, [2019-03-17T16:54:49.500295 #46856]  INFO -- : [Generate Swagger schema files] start
I, [2019-03-17T16:54:49.523519 #46856]  INFO -- : <From schema files>
I, [2019-03-17T16:54:49.524119 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-03-17T16:54:49.524509 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:49.525053 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:49.525392 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:49.526041 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:49.527038 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:49.527304 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:49.528432 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:49.528612 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-03-17T16:54:49.529722 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-03-17T16:54:49.530027 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-03-17T16:54:49.530347 #46856]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-03-17T16:54:49.549819 #46856]  INFO -- : <Update schema files>
I, [2019-03-17T16:54:49.569043 #46856]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-03-17T16:54:49.569765 #46856]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-03-17T16:54:49.571002 #46856]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-03-17T16:54:49.571044 #46856]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-03-17T16:54:49.589225 #46856]  INFO -- :  <From schema files>
I, [2019-03-17T16:54:49.589799 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:49.590198 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:49.590557 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:49.591016 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:49.591391 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:49.591592 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:49.592263 #46856]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:49.592539 #46856]  INFO -- :  <Update schema files (paths)>
I, [2019-03-17T16:54:49.593116 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:49.594214 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:49.595061 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:49.595931 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:49.596811 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:49.597706 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:49.599774 #46856]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:49.599809 #46856]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-03-17T16:54:49.600113 #46856]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-03-17T16:54:49.600459 #46856]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-03-17T16:54:49.600482 #46856]  INFO -- : [Generate Swagger schema files] end
I, [2019-03-17T16:54:49.600496 #46856]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-03-17T16:54:49.600893 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-03-17T16:54:49.601240 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-03-17T16:54:49.601649 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-03-17T16:54:49.602124 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-03-17T16:54:49.602698 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-03-17T16:54:49.603179 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-03-17T16:54:49.603416 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-03-17T16:54:49.604173 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-03-17T16:54:49.604317 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-03-17T16:54:49.604653 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-03-17T16:54:49.604875 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-03-17T16:54:49.604996 #46856]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-03-17T16:54:49.611405 #46856]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-03-17T16:54:49.611451 #46856]  INFO -- : [Routes to Swagger docs] end
```

Generate like this:

```
swagger_docs
├── schema
│   ├── externalDocs.yml
│   ├── info.yml
│   ├── openapi.yml
│   ├── paths
│   │   ├── api
│   │   │   ├── v1
│   │   │   │   ├── post.yml
│   │   │   │   └── task.yml
│   │   │   └── v2
│   │   │       └── post.yml
│   │   ├── rails_admin
│   │   │   ├── engine.yml
│   │   │   └── main.yml
│   │   ├── task.yml
│   │   └── user.yml
│   ├── servers.yml
│   └── tags.yml
└── swagger_doc.yml
```

## Advanced Usage

If you want to generate docs by squeezing unit paths (For example, `api/v1/task.yml`), 
you set UNIT_PATHS_FILE_PATH environment like this:

```bash
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:docs
```

```
I, [2019-04-07T19:18:37.478650 #32978]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-07T19:18:37.585622 #32978]  INFO -- : [Generate Swagger schema files] start
I, [2019-04-07T19:18:37.585786 #32978]  INFO -- : <From schema files>
I, [2019-04-07T19:18:37.587302 #32978]  INFO -- :  Fetch schema file: 	../swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-07T19:18:37.587865 #32978]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-04-07T19:18:37.588549 #32978]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:18:37.589428 #32978]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-04-07T19:18:37.589899 #32978]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-04-07T19:18:37.590411 #32978]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-04-07T19:18:37.590505 #32978]  INFO -- : <Update schema files>
I, [2019-04-07T19:18:37.591127 #32978]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-04-07T19:18:37.591617 #32978]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-04-07T19:18:37.592455 #32978]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-04-07T19:18:37.592477 #32978]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-04-07T19:18:37.622570 #32978]  INFO -- :  <From schema files>
I, [2019-04-07T19:18:37.623078 #32978]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:18:37.623139 #32978]  INFO -- :  <Update schema files (paths)>
I, [2019-04-07T19:18:37.623898 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:18:37.625018 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:18:37.625798 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:18:37.626779 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:18:37.627636 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:18:37.628434 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:18:37.629968 #32978]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:18:37.629988 #32978]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-04-07T19:18:37.630307 #32978]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:18:37.630702 #32978]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-04-07T19:18:37.630755 #32978]  INFO -- : [Generate Swagger schema files] end
I, [2019-04-07T19:18:37.630767 #32978]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-04-07T19:18:37.631307 #32978]  INFO -- :  Use schema file: 	../swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-07T19:18:37.631430 #32978]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/openapi.yml
I, [2019-04-07T19:18:37.631542 #32978]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:18:37.631828 #32978]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/tags.yml
I, [2019-04-07T19:18:37.632022 #32978]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/info.yml
I, [2019-04-07T19:18:37.632137 #32978]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/src/servers.yml
I, [2019-04-07T19:18:37.634667 #32978]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-04-07T19:18:37.634690 #32978]  INFO -- : [Routes to Swagger docs] end
```
