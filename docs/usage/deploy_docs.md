# Deploy docs

## Prepare

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

## Command

```bash
$ bundle exec rake routes:oas:deploy
```

## Example

if there is `oas_doc.yml` like this:

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
$ be rake routes:oas:deploy
I, [2019-05-06T19:32:52.014417 #22431]  INFO -- : [R2-OAS] start
I, [2019-05-06T19:32:52.075691 #22431]  INFO -- : [Build OAS schema files] start
I, [2019-05-06T19:32:52.075731 #22431]  INFO -- : [Build OAS schema files] end
I, [2019-05-06T19:32:52.075743 #22431]  INFO -- : [Build OAS docs from schema files] start
I, [2019-05-06T19:32:52.079267 #22431]  INFO -- :  Use schema file: 	oas_docs/src/openapi.yml
I, [2019-05-06T19:32:52.080334 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/user.yml
I, [2019-05-06T19:32:52.081189 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/api/v1/task.yml
I, [2019-05-06T19:32:52.081944 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/api/v1/post.yml
I, [2019-05-06T19:32:52.082838 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/api/v2/post.yml
I, [2019-05-06T19:32:52.083719 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/task.yml
I, [2019-05-06T19:32:52.084185 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/rails_admin/engine.yml
I, [2019-05-06T19:32:52.085796 #22431]  INFO -- :  Use schema file: 	oas_docs/src/paths/rails_admin/main.yml
I, [2019-05-06T19:32:52.086063 #22431]  INFO -- :  Use schema file: 	oas_docs/src/externalDocs.yml
I, [2019-05-06T19:32:52.086555 #22431]  INFO -- :  Use schema file: 	oas_docs/src/tags.yml
I, [2019-05-06T19:32:52.087145 #22431]  INFO -- :  Use schema file: 	oas_docs/src/components/schemas/user.yml
I, [2019-05-06T19:32:52.087667 #22431]  INFO -- :  Use schema file: 	oas_docs/src/components/schemas/task.yml
I, [2019-05-06T19:32:52.087955 #22431]  INFO -- :  Use schema file: 	oas_docs/src/components/schemas/engine.yml
I, [2019-05-06T19:32:52.088281 #22431]  INFO -- :  Use schema file: 	oas_docs/src/components/schemas/main.yml
I, [2019-05-06T19:32:52.088567 #22431]  INFO -- :  Use schema file: 	oas_docs/src/components/schemas/post.yml
I, [2019-05-06T19:32:52.088867 #22431]  INFO -- :  Use schema file: 	oas_docs/src/info.yml
I, [2019-05-06T19:32:52.089136 #22431]  INFO -- :  Use schema file: 	oas_docs/src/servers.yml
I, [2019-05-06T19:32:52.100673 #22431]  INFO -- : [Build OAS docs from schema files] end
I, [2019-05-06T19:32:52.133732 #22431]  INFO -- : [R2-OAS] end
```

Generate docs like this:

```
$ tree docs
docs
├── dist
│   ├── favicon-16x16.png
│   ├── favicon-32x32.png
│   ├── oauth2-redirect.html
│   ├── swagger-ui-bundle.js
│   ├── swagger-ui-bundle.js.map
│   ├── swagger-ui-standalone-preset.js
│   ├── swagger-ui-standalone-preset.js.map
│   ├── swagger-ui.css
│   ├── swagger-ui.css.map
│   ├── swagger-ui.js
│   └── swagger-ui.js.map
├── index.html
└── oas_doc.yml

1 directory, 13 files
```
