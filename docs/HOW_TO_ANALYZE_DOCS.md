## Basic Usage

```ruby

require 'r2-oas'

R2OAS.configure do |config|
   # default setting        
   config.root_dir_path        = "./oas_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "oas_doc.yml"
end
```

```bash
$ SWAGGER_FILE="~/Desktop/swagger_file.yml" bundle exec rake routes:oas:analyze
```

## Example

if there is `swagger_file.yml` like this:

<details>

```yaml
---
openapi: 3.0.0
paths:
  "/users":
    post:
      tags:
      - user
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: user description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/User"
      deprecated: false
  "/users/new":
    get:
      tags:
      - user
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: user description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/User"
      deprecated: false
  "/users/:id/edit":
    get:
      tags:
      - user
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: user description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/User"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/users/:id":
    delete:
      tags:
      - user
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: user description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/User"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v1/tasks":
    post:
      tags:
      - api/v1/task
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
  "/api/v1/tasks/new":
    get:
      tags:
      - api/v1/task
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
  "/api/v1/tasks/:id/edit":
    get:
      tags:
      - api/v1/task
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v1/tasks/:id":
    delete:
      tags:
      - api/v1/task
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: api/v1/task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v1/posts":
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
  "/api/v1/posts/new":
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
  "/api/v1/posts/:id/edit":
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
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v1/posts/:id":
    delete:
      tags:
      - api/v1/post
      summary: delete summary
      description: delete description
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
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v2/posts":
    post:
      tags:
      - api/v2/post
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: responses description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
  "/api/v2/posts/new":
    get:
      tags:
      - api/v2/post
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: responses description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
  "/api/v2/posts/:id/edit":
    get:
      tags:
      - api/v2/post
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: responses description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/api/v2/posts/:id":
    delete:
      tags:
      - api/v2/post
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: responses description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Post"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/tasks":
    post:
      tags:
      - task
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
  "/tasks/new":
    get:
      tags:
      - task
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
  "/tasks/:id/edit":
    get:
      tags:
      - task
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/tasks/:id":
    delete:
      tags:
      - task
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: task description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Task"
      deprecated: false
      parameters:
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/subadmin":
    get:
      tags:
      - rails_admin/engine
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/engine description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Engine"
      deprecated: false
  "/admin":
    get:
      tags:
      - rails_admin/engine
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/engine description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Engine"
      deprecated: false
  "/":
    get:
      tags:
      - rails_admin/main
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
  "/:model_name":
    post:
      tags:
      - rails_admin/main
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
  "/:model_name/new":
    post:
      tags:
      - rails_admin/main
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
  "/:model_name/export":
    post:
      tags:
      - rails_admin/main
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
  "/:model_name/bulk_delete":
    delete:
      tags:
      - rails_admin/main
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
  "/:model_name/bulk_action":
    post:
      tags:
      - rails_admin/main
      summary: post summary
      description: post description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
  "/:model_name/:id":
    get:
      tags:
      - rails_admin/main
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/:model_name/:id/edit":
    put:
      tags:
      - rails_admin/main
      summary: put summary
      description: put description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/:model_name/:id/delete":
    delete:
      tags:
      - rails_admin/main
      summary: delete summary
      description: delete description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
  "/:model_name/:id/show_in_app":
    get:
      tags:
      - rails_admin/main
      summary: get summary
      description: get description
      responses:
        default:
          description: ''
        '200':
          description: rails_admin/main description
          content:
            application/json:
              schema:
                "$ref": "#/components/schemas/Main"
      deprecated: false
      parameters:
      - name: model_name
        in: path
        description: model_name
        required: true
        schema:
          type: string
      - name: id
        in: path
        description: id
        required: true
        schema:
          type: integer
externalDocs:
  description: ''
  url: ''
tags:
- name: rails_admin/engine
  description: rails_admin/engine description
  externalDocs:
    description: description
    url: url
- name: api/v2/post
  description: api/v2/post description
  externalDocs:
    description: description
    url: url
- name: api/v1/post
  description: api/v1/post description
  externalDocs:
    description: description
    url: url
- name: api/v1/task
  description: api/v1/task description
  externalDocs:
    description: description
    url: url
- name: task
  description: task description
  externalDocs:
    description: description
    url: url
- name: user
  description: user description
  externalDocs:
    description: description
    url: url
- name: rails_admin/main
  description: rails_admin/main description
  externalDocs:
    description: description
    url: url
components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: integer
          format: int64
    Task:
      type: object
      properties:
        id:
          type: integer
          format: int64
    Engine:
      type: object
      properties:
        id:
          type: integer
          format: int64
    Main:
      type: object
      properties:
        id:
          type: integer
          format: int64
    Post:
      type: object
      properties:
        id:
          type: integer
          format: int64
info:
  title: Swagger API Document Title
  description: |-
    This is a sample server Petstore server.  You can find out more about
                Swagger at [http://swagger.io](http://swagger.io) or on [irc.freenode.net,
                #swagger](http://swagger.io/irc/).  For this sample, you can use the api key
                `special-key` to test the authorization filters.
  termsOfService: http://swagger.io/terms/
  contact:
    name: ''
    url: ''
  license:
    name: ''
    url: ''
  version: 1.0.0
servers:
- url: http://localhost:3000
  description: localhost
```

</details>


```
$ SWAGGER_FILE=~/Desktop/swagger_file.yml be rake routes:oas:analyze
I, [2019-05-05T15:00:40.716815 #18669]  INFO -- : [R2-OAS] start
I, [2019-05-05T15:00:40.756046 #18669]  INFO -- : [Analyze Swagger file] start
I, [2019-05-05T15:00:40.758453 #18669]  INFO -- : [Analyze Swagger file (paths)] start
I, [2019-05-05T15:00:40.763028 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/user.yml
I, [2019-05-05T15:00:40.775377 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/task.yml
I, [2019-05-05T15:00:40.776937 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/post.yml
I, [2019-05-05T15:00:40.778774 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/post.yml
I, [2019-05-05T15:00:40.780856 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/task.yml
I, [2019-05-05T15:00:40.782192 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/engine.yml
I, [2019-05-05T15:00:40.787576 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/main.yml
I, [2019-05-05T15:00:40.787615 #18669]  INFO -- : [Analyze Swagger file (paths)] end
I, [2019-05-05T15:00:40.788014 #18669]  INFO -- : [Analyze Swagger file (tags)] start
I, [2019-05-05T15:00:40.788948 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/tags.yml
I, [2019-05-05T15:00:40.788972 #18669]  INFO -- : [Analyze Swagger file (tags)] end
I, [2019-05-05T15:00:40.788985 #18669]  INFO -- : [Analyze Swagger file (components)] start
I, [2019-05-05T15:00:40.788999 #18669]  INFO -- : [Analyze Swagger file (components/schemas)] start
I, [2019-05-05T15:00:40.790696 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user.yml
I, [2019-05-05T15:00:40.791151 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/task.yml
I, [2019-05-05T15:00:40.791635 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/engine.yml
I, [2019-05-05T15:00:40.792107 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/main.yml
I, [2019-05-05T15:00:40.792495 #18669]  INFO -- :   Write schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/post.yml
I, [2019-05-05T15:00:40.792515 #18669]  INFO -- : [Analyze Swagger file (components/schemas)] end
I, [2019-05-05T15:00:40.792526 #18669]  INFO -- : [Analyze Swagger file (components)] end
I, [2019-05-05T15:00:40.793238 #18669]  INFO -- : [Analyze Swagger file] end
I, [2019-05-05T15:00:40.848054 #18669]  INFO -- : [Generate Swagger schema files] start
I, [2019-05-05T15:00:40.848102 #18669]  INFO -- : [Generate Swagger schema files] end
I, [2019-05-05T15:00:40.848115 #18669]  INFO -- : [Generate Swagger docs from schema files] start
I, [2019-05-05T15:00:40.848612 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/openapi.yml
I, [2019-05-05T15:00:40.849247 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/user.yml
I, [2019-05-05T15:00:40.850005 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/task.yml
I, [2019-05-05T15:00:40.850882 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/post.yml
I, [2019-05-05T15:00:40.851566 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/post.yml
I, [2019-05-05T15:00:40.852122 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/task.yml
I, [2019-05-05T15:00:40.852441 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/engine.yml
I, [2019-05-05T15:00:40.853853 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/main.yml
I, [2019-05-05T15:00:40.853983 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/externalDocs.yml
I, [2019-05-05T15:00:40.854312 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/tags.yml
I, [2019-05-05T15:00:40.854465 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/user.yml
I, [2019-05-05T15:00:40.854613 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/task.yml
I, [2019-05-05T15:00:40.854796 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/engine.yml
I, [2019-05-05T15:00:40.854978 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/main.yml
I, [2019-05-05T15:00:40.855185 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/components/schemas/post.yml
I, [2019-05-05T15:00:40.855543 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/info.yml
I, [2019-05-05T15:00:40.855888 #18669]  INFO -- :  Use schema file: 	/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/servers.yml
I, [2019-05-05T15:00:40.872235 #18669]  INFO -- : [Generate Swagger docs from schema files] end
I, [2019-05-05T15:00:40.872286 #18669]  INFO -- : [R2-OAS] end
```

Generate like this:

```
$ tree ../oas_docs
../oas_docs
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
└── oas_doc.yml

8 directories, 18 files
```
