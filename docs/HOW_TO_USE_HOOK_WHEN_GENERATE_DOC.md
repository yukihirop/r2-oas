## BasicUsage

`custom_path_item_object.rb`

```ruby
class CustomPathItemObject < R2OAS::Schema::V3::PathItemObject

  # [Important] Please change doc destructively.
  before_create do |doc, path|
    # [Important] To be able to use methods in Rails !
    #
    # doc is {}.
    doc.merge!({
    })
  end

  # [Important] Please change doc destructively.
  after_create do |doc, path|
    # [Important] To be able to use methods in Rails !
    
    # For example, doc (style is yaml) is like that:
    # get:
    #   tags:
    #   - api/v1/post
    #   summary: get summary
    #   description: get description
    #   responses:
    #     default:
    #       description: ''
    #     '200':
    #       description: api/v1/post description
    #       content:
    #         application/json:
    #           schema:
    #             "$ref": "#/components/schemas/Post"
    #   deprecated: false
    #

    # If you want to merge `sort` query parameters when request is GET api/v1/post.
    if doc['get'].present? && path == 'api/v1/post'
      doc['get'].merge!({
        'parameters' => {
          'name' => 'sort',
          'in' => 'query',
          'description' => 'option to sort posts',
          'required' => false,
          'deprecated' => false
        }
      })
    end
  end
end
```

```ruby
require_relative 'custom_path_item_object'

R2OAS.configure do |config|
  config.root_dir_path        = "./swagger_docs"
  config.schema_save_dir_name = "src"
  config.doc_save_file_name   = "swagger_doc.yml"
  config.force_update_schema  = false
  config.use_tag_namespace    = true
  config.use_schema_namespace = false
  config.server.data = [
    {
      url: "http://localhost:3000",
      description: "localhost"
    }
  ]
  config.interval_to_save_edited_tmp_schema = 15
  config.use_object_classes.merge!({
    path_item_object:  CustomPathItemObject
  })
end
```

```bash
$ bundle exec rake routes:oas:docs
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
$ bundle exec rake routes:oas:docs
I, [2019-06-02T22:12:41.530676 #61323]  INFO -- : [Routes to Swagger docs] start
I, [2019-06-02T22:12:41.609492 #61323]  INFO -- : [Generate Swagger schema files] start
I, [2019-06-02T22:12:41.609574 #61323]  INFO -- : <From routes data>
I, [2019-06-02T22:12:41.609591 #61323]  INFO -- : <Update schema files>
I, [2019-06-02T22:12:41.611183 #61323]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-06-02T22:12:41.611676 #61323]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-06-02T22:12:41.612596 #61323]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-06-02T22:12:41.612619 #61323]  INFO -- :  [Generate Swagger schema files (paths)] start
I, [2019-06-02T22:12:41.612765 #61323]  INFO -- :  <From routes data>
I, [2019-06-02T22:12:41.612782 #61323]  INFO -- :  <Update schema files (paths)>
I, [2019-06-02T22:12:41.614701 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-06-02T22:12:41.618979 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-06-02T22:12:41.623081 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-06-02T22:12:41.630184 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-06-02T22:12:41.633369 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-06-02T22:12:41.636323 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-06-02T22:12:41.642353 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-06-02T22:12:41.642381 #61323]  INFO -- :  [Generate Swagger schema files (paths)] end
I, [2019-06-02T22:12:41.642664 #61323]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-06-02T22:12:41.642993 #61323]  INFO -- :  Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-06-02T22:12:41.643015 #61323]  INFO -- :  [Generate Swagger schema files (components)] start
I, [2019-06-02T22:12:41.643335 #61323]  INFO -- :  <From routes data>
I, [2019-06-02T22:12:41.643421 #61323]  INFO -- :  <Update Components schema files (components/schemas)>
I, [2019-06-02T22:12:41.645158 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/engine.yml
I, [2019-06-02T22:12:41.645613 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/post.yml
I, [2019-06-02T22:12:41.645987 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/task.yml
I, [2019-06-02T22:12:41.646443 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/user.yml
I, [2019-06-02T22:12:41.646833 #61323]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/main.yml
I, [2019-06-02T22:12:41.646853 #61323]  INFO -- :  [Generate Swagger schema files (components)] end
I, [2019-06-02T22:12:41.646865 #61323]  INFO -- : [Generate Swagger schema files] end
I, [2019-06-02T22:12:41.646874 #61323]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-06-02T22:12:41.647400 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/openapi.yml
I, [2019-06-02T22:12:41.648404 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/user.yml
I, [2019-06-02T22:12:41.649983 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/task.yml
I, [2019-06-02T22:12:41.651386 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v1/post.yml
I, [2019-06-02T22:12:41.652608 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/api/v2/post.yml
I, [2019-06-02T22:12:41.654068 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/task.yml
I, [2019-06-02T22:12:41.654754 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/engine.yml
I, [2019-06-02T22:12:41.658028 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/paths/rails_admin/main.yml
I, [2019-06-02T22:12:41.658622 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/externalDocs.yml
I, [2019-06-02T22:12:41.659216 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/tags.yml
I, [2019-06-02T22:12:41.659715 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/user.yml
I, [2019-06-02T22:12:41.660165 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/task.yml
I, [2019-06-02T22:12:41.660528 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/engine.yml
I, [2019-06-02T22:12:41.660788 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/main.yml
I, [2019-06-02T22:12:41.661004 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/components/schemas/post.yml
I, [2019-06-02T22:12:41.661261 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/info.yml
I, [2019-06-02T22:12:41.661520 #61323]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/swagger_docs/src/servers.yml
I, [2019-06-02T22:12:41.686435 #61323]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-06-02T22:12:41.686477 #61323]  INFO -- : [Routes to Swagger docs] end
```

`swagger_docs/schema/paths/api/v1/post` is generated like that:

```diff
---
paths:
  "/api/v1/posts":
    get:
      tags:
      - api/v1/post
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/post description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
+     parameters:
+     - name: sort
+       in: query
+       description: option to sort posts
+       required: false
+       deprecated: false
    post:
      tags:
      - api/v1/post
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/post description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
```


