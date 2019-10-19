## Basic Usage

```ruby

require 'r2-oas'

R2OAS.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
end
```

```bash
$ bundle exec rake routes:oas:editor
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

The editor starts up with the schema set.

<img alt="swagger_editor" src="https://user-images.githubusercontent.com/11146767/55682235-a8361480-596b-11e9-8c0c-718c8eed1393.png" width="546">

```
I, [2019-04-07T19:24:44.832837 #33139]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-07T19:24:44.832980 #33139]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-07T19:24:44.941617 #33139]  INFO -- : [Generate Swagger schema files] start
I, [2019-04-07T19:24:44.941859 #33139]  INFO -- : <From schema files>
I, [2019-04-07T19:24:44.943345 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:24:44.944161 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:24:44.944934 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:24:44.945433 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:24:44.946134 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:24:44.946595 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:24:44.947051 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:24:44.947883 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:24:44.948154 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:24:44.948699 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:24:44.949193 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:24:44.949423 #33139]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:24:44.949694 #33139]  INFO -- : <Update schema files>
I, [2019-04-07T19:24:44.950397 #33139]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:24:44.950846 #33139]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:24:44.951710 #33139]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:24:44.951779 #33139]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-04-07T19:24:44.980847 #33139]  INFO -- :  <From schema files>
I, [2019-04-07T19:24:44.981390 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:24:44.981742 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:24:44.982088 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:24:44.982510 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:24:44.982843 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:24:44.983202 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:24:44.984177 #33139]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:24:44.984565 #33139]  INFO -- :  <Update schema files (paths)>
I, [2019-04-07T19:24:44.985294 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:24:44.986665 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:24:44.987585 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:24:44.988493 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:24:44.989595 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:24:44.990660 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:24:44.992520 #33139]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:24:44.992553 #33139]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-04-07T19:24:44.992863 #33139]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:24:44.993229 #33139]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:24:44.993272 #33139]  INFO -- : [Generate Swagger schema files] end
I, [2019-04-07T19:24:44.993311 #33139]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-04-07T19:24:44.993774 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:24:44.994197 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:24:44.994627 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:24:44.994967 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:24:44.995438 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:24:44.995860 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:24:44.996097 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:24:44.996770 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:24:44.996885 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:24:44.997187 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:24:44.997401 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:24:44.997522 #33139]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:24:45.003195 #33139]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-04-07T19:24:45.003223 #33139]  INFO -- : [Routes to Swagger docs] end

wait for single trap ...

```

When you press `Ctrl + C` after edit schema , the editor closes and the following message appears.

```
^C
save updated schema in tempfile path: tmp/edited_schema20190407-33493-mxw638.yaml
container id: 1a9752d2702045b2fde587dda3ce064233a735165f9b70bc6f86e603abfe3a39 removed
I, [2019-04-07T19:43:53.666565 #33493]  INFO -- : [Routes to Swagger docs] end
```

## Advanced Usage

If you want to generate docs by squeezing unit paths (For example, `api/v1/task.yml`), 
you set PATHS_FILE environment like this:

```bash
$ PATHS_FILE="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:editor
```

```
I, [2019-04-07T19:48:40.140872 #34907]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-07T19:48:40.140990 #34907]  INFO -- : [Routes to Swagger docs] start
I, [2019-04-07T19:48:40.252636 #34907]  INFO -- : [Generate Swagger schema files] start
I, [2019-04-07T19:48:40.252835 #34907]  INFO -- : <From schema files>
I, [2019-04-07T19:48:40.253463 #34907]  INFO -- :  Fetch schema file: 	../swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-07T19:48:40.253587 #34907]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:48:40.253707 #34907]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:48:40.254045 #34907]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:48:40.254276 #34907]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:48:40.254430 #34907]  INFO -- :  Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:48:40.254522 #34907]  INFO -- : <Update schema files>
I, [2019-04-07T19:48:40.255059 #34907]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:48:40.255565 #34907]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:48:40.256410 #34907]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:48:40.256433 #34907]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-04-07T19:48:40.287252 #34907]  INFO -- :  <From schema files>
I, [2019-04-07T19:48:40.288195 #34907]  INFO -- :   Fetch schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:48:40.288253 #34907]  INFO -- :  <Update schema files (paths)>
I, [2019-04-07T19:48:40.289027 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-04-07T19:48:40.290245 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-04-07T19:48:40.291226 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-04-07T19:48:40.292277 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-04-07T19:48:40.293109 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-04-07T19:48:40.294190 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-04-07T19:48:40.296321 #34907]  INFO -- :   Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-04-07T19:48:40.296357 #34907]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-04-07T19:48:40.296651 #34907]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:48:40.297043 #34907]  INFO -- :  Merge schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:48:40.297068 #34907]  INFO -- : [Generate Swagger schema files] end
I, [2019-04-07T19:48:40.297093 #34907]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-04-07T19:48:40.297631 #34907]  INFO -- :  Use schema file: 	../swagger_docs/schema/paths/api/v1/task.yml
I, [2019-04-07T19:48:40.297797 #34907]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-04-07T19:48:40.297956 #34907]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-04-07T19:48:40.298421 #34907]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-04-07T19:48:40.298720 #34907]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-04-07T19:48:40.298994 #34907]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-04-07T19:48:40.302896 #34907]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-04-07T19:48:40.302938 #34907]  INFO -- : [Routes to Swagger docs] end

wait for single trap ...

```

When you press `Ctrl + C` after edit schema , the editor closes and the following message appears.

```
^C
save updated schema in tempfile path: tmp/edited_schema20190407-34907-1iv0ao0.yaml
container id: 7b58246777eabb9206d852e587a491e0815444982779985dbd2e27c30cbfff59 removed
I, [2019-04-07T19:50:26.402777 #34907]  INFO -- : [Routes to Swagger docs] end
```
