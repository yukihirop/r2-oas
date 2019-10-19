## Use Schema Namespace (default)

```ruby

require 'r2-oas'

R2OAS.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
   # default
   config.use_tag_namespace    = true
   config.use_schema_namespace = true # write here
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

<img alt="swagger_ui" src="https://user-images.githubusercontent.com/11146767/56959813-c1586c80-6b89-11e9-9903-da95d25858f0.png" width="546">

Generate like this:

```
swagger_docs
├── schema
│   ├── components
│   │   └── schemas
│   │       ├── api
│   │       │   ├── v1
│   │       │   │   ├── post.yml
│   │       │   │   └── task.yml
│   │       │   └── v2
│   │       │       └── post.yml
│   │       ├── rails_admin
│   │       │   ├── engine.yml
│   │       │   └── main.yml
│   │       ├── task.yml
│   │       └── user.yml
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

## Do not Use Tag Namespace

```ruby

require 'r2-oas'

R2OAS.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
   config.use_tag_namespace    = true
   config.use_schema_namespace = false # write here
end
```

```bash
$ bundle exec rake routes:swagger:docs
```

<img alt="swagger_ui" src="https://user-images.githubusercontent.com/11146767/57007768-134ed000-6c26-11e9-9b4e-60f58c78221e.png" width="546">

Generate like this:

```
swagger_docs
├── schema
│   ├── components
│   │   └── schemas
│   │       ├── engine.yml
│   │       ├── main.yml
│   │       ├── post.yml
│   │       ├── task.yml
│   │       └── user.yml
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
