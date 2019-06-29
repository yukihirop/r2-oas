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
$ bundle exec rake routes:swagger:ui
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

The ui starts up with the schema set.

<img alt="swagger_ui" src="https://user-images.githubusercontent.com/11146767/56875699-6d606180-6a7d-11e9-9947-4edae2fd48cb.png" width="546">

```
I, [2019-04-29T12:53:03.010443 #10516]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-29T12:53:03.010557 #10516]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-29T12:53:03.133380 #10516]  INFO -- : [Generate Swagger schema files] start
I, [2019-04-29T12:53:03.133776 #10516]  INFO -- : <From schema files>
I, [2019-04-29T12:53:03.135212 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:53:03.136340 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/user.yml
I, [2019-04-29T12:53:03.137207 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:53:03.137860 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/post.yml
I, [2019-04-29T12:53:03.138488 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v2/post.yml
I, [2019-04-29T12:53:03.139113 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/task.yml
I, [2019-04-29T12:53:03.139660 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/engine.yml
I, [2019-04-29T12:53:03.141082 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/main.yml
I, [2019-04-29T12:53:03.141426 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:53:03.142055 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:53:03.142364 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/user.yml
I, [2019-04-29T12:53:03.142690 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:53:03.143078 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/post.yml
I, [2019-04-29T12:53:03.143408 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v2/post.yml
I, [2019-04-29T12:53:03.143643 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/task.yml
I, [2019-04-29T12:53:03.143971 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/engine.yml
I, [2019-04-29T12:53:03.144315 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/main.yml
I, [2019-04-29T12:53:03.144806 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:53:03.145013 #10516]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:53:03.145597 #10516]  INFO -- : <Update schema files>
I, [2019-04-29T12:53:03.146179 #10516]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:53:03.146613 #10516]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:53:03.147470 #10516]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:53:03.147492 #10516]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-04-29T12:53:03.183824 #10516]  INFO -- :  <From schema files>
I, [2019-04-29T12:53:03.184629 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/user.yml
I, [2019-04-29T12:53:03.185143 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:53:03.185661 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/post.yml
I, [2019-04-29T12:53:03.186202 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v2/post.yml
I, [2019-04-29T12:53:03.186675 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/task.yml
I, [2019-04-29T12:53:03.187142 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/engine.yml
I, [2019-04-29T12:53:03.188050 #10516]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/main.yml
I, [2019-04-29T12:53:03.188673 #10516]  INFO -- :  <Update schema files (paths)>
I, [2019-04-29T12:53:03.189751 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/engine.yml
I, [2019-04-29T12:53:03.190945 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v2/post.yml
I, [2019-04-29T12:53:03.192400 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/post.yml
I, [2019-04-29T12:53:03.193803 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:53:03.195408 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/task.yml
I, [2019-04-29T12:53:03.196820 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/user.yml
I, [2019-04-29T12:53:03.199474 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/main.yml
I, [2019-04-29T12:53:03.199496 #10516]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-04-29T12:53:03.199768 #10516]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:53:03.200231 #10516]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:53:03.200257 #10516]  INFO -- :  [Generate Swagger schema files (components)] start
I, [2019-04-29T12:53:03.268381 #10516]  INFO -- :  <From schema files>
I, [2019-04-29T12:53:03.268772 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/user.yml
I, [2019-04-29T12:53:03.268969 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:53:03.269135 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/post.yml
I, [2019-04-29T12:53:03.269280 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v2/post.yml
I, [2019-04-29T12:53:03.269427 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/task.yml
I, [2019-04-29T12:53:03.269642 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/engine.yml
I, [2019-04-29T12:53:03.269793 #10516]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/main.yml
I, [2019-04-29T12:53:03.269847 #10516]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2019-04-29T12:53:03.270491 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/engine.yml
I, [2019-04-29T12:53:03.271096 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v2/post.yml
I, [2019-04-29T12:53:03.271632 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/post.yml
I, [2019-04-29T12:53:03.272166 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:53:03.272620 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/task.yml
I, [2019-04-29T12:53:03.273053 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/user.yml
I, [2019-04-29T12:53:03.273541 #10516]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/main.yml
I, [2019-04-29T12:53:03.273562 #10516]  INFO -- :  [Generate Swagger schema files (components)] end
I, [2019-04-29T12:53:03.273574 #10516]  INFO -- : [Generate Swagger schema files] end
I, [2019-04-29T12:53:03.273584 #10516]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-04-29T12:53:03.274133 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:53:03.274566 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/user.yml
I, [2019-04-29T12:53:03.275000 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:53:03.275443 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/post.yml
I, [2019-04-29T12:53:03.276159 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v2/post.yml
I, [2019-04-29T12:53:03.277020 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/task.yml
I, [2019-04-29T12:53:03.277364 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/engine.yml
I, [2019-04-29T12:53:03.278296 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/main.yml
I, [2019-04-29T12:53:03.278432 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:53:03.278747 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:53:03.278897 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/user.yml
I, [2019-04-29T12:53:03.279043 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:53:03.279210 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/post.yml
I, [2019-04-29T12:53:03.279356 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v2/post.yml
I, [2019-04-29T12:53:03.279566 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/task.yml
I, [2019-04-29T12:53:03.279759 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/engine.yml
I, [2019-04-29T12:53:03.279935 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/main.yml
I, [2019-04-29T12:53:03.280107 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:53:03.280223 #10516]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:53:03.301656 #10516]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-04-29T12:53:03.301698 #10516]  INFO -- : [Routes to Swagger docs] end

wait for single trap ...

```

When you press `Ctrl + C` , the ui closes and the following message appears.

```
^Ccontainer id: edd950ec30507b1138af1b714f0101ef0452d32d08b66e23eb6e22740c830576 removed
I, [2019-04-29T12:54:14.333082 #10516]  INFO -- : [Routes to Swagger docs] end
```

## Advanced Usage

If you want to generate docs by squeezing unit paths (For example, `api/v1/task.yml`), 
you set UNIT_PATHS_FILE_PATH environment like this:

```bash
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:editor
```

<img alt="swagger_ui_by_specify_schemas" src="https://user-images.githubusercontent.com/11146767/56875847-38084380-6a7e-11e9-90db-9710459da44c.png" width="546">

```
I, [2019-04-29T12:55:15.434226 #10698]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-29T12:55:15.434334 #10698]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-29T12:55:15.550674 #10698]  INFO -- : [Generate Swagger schema files] start
I, [2019-04-29T12:55:15.551016 #10698]  INFO -- : <From schema files>
I, [2019-04-29T12:55:15.551724 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:55:15.551870 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:55:15.552005 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:55:15.552257 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:55:15.552608 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:55:15.552847 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:55:15.553001 #10698]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:55:15.553144 #10698]  INFO -- : <Update schema files>
I, [2019-04-29T12:55:15.553650 #10698]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:55:15.554101 #10698]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:55:15.555634 #10698]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:55:15.555714 #10698]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-04-29T12:55:15.589466 #10698]  INFO -- :  <From schema files>
I, [2019-04-29T12:55:15.590112 #10698]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:55:15.590216 #10698]  INFO -- :  <Update schema files (paths)>
I, [2019-04-29T12:55:15.591618 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/engine.yml
I, [2019-04-29T12:55:15.593567 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v2/post.yml
I, [2019-04-29T12:55:15.595107 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/post.yml
I, [2019-04-29T12:55:15.596491 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:55:15.598158 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/task.yml
I, [2019-04-29T12:55:15.599531 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/user.yml
I, [2019-04-29T12:55:15.602490 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/rails_admin/main.yml
I, [2019-04-29T12:55:15.602516 #10698]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-04-29T12:55:15.602822 #10698]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:55:15.603159 #10698]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:55:15.603181 #10698]  INFO -- :  [Generate Swagger schema files (components)] start
I, [2019-04-29T12:55:15.669796 #10698]  INFO -- :  <From schema files>
I, [2019-04-29T12:55:15.670091 #10698]  INFO -- :   Fetch Components schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:55:15.670122 #10698]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2019-04-29T12:55:15.670729 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/engine.yml
I, [2019-04-29T12:55:15.671278 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v2/post.yml
I, [2019-04-29T12:55:15.671796 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/post.yml
I, [2019-04-29T12:55:15.672328 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:55:15.672745 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/task.yml
I, [2019-04-29T12:55:15.673160 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/user.yml
I, [2019-04-29T12:55:15.673729 #10698]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/rails_admin/main.yml
I, [2019-04-29T12:55:15.673771 #10698]  INFO -- :  [Generate Swagger schema files (components)] end
I, [2019-04-29T12:55:15.673785 #10698]  INFO -- : [Generate Swagger schema files] end
I, [2019-04-29T12:55:15.673830 #10698]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-04-29T12:55:15.674608 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-29T12:55:15.674796 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/components/schemas/api/v1/task.yml
I, [2019-04-29T12:55:15.675010 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/openapi.yml
I, [2019-04-29T12:55:15.675144 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/externalDocs.yml
I, [2019-04-29T12:55:15.675523 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/tags.yml
I, [2019-04-29T12:55:15.675700 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/info.yml
I, [2019-04-29T12:55:15.675817 #10698]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/routes_to_swagger_docs/example/swagger_docs/schema/servers.yml
I, [2019-04-29T12:55:15.679925 #10698]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-04-29T12:55:15.679950 #10698]  INFO -- : [Routes to Swagger docs] end

wait for single trap ...

```

When you press `Ctrl + C` , the ui closes and the following message appears.

```
^Ccontainer id: dfb4752353f17dd8c1eb60ea53049575ce9e0cf04d928499441dc06754955875 removed
I, [2019-04-29T12:58:02.840740 #10698]  INFO -- : [Routes to Swagger docs] end
```
