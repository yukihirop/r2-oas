# RoutesToSwaggerDocs

Generate api docment(OpenAPI) side only from `rails` routing.

Provides rake commands to help `generate`, `edit`, `view` and `manage`.

```bash
bundle exec rake routes:swagger:docs    # generate
bundle exec rake routes:swagger:ui      # view
bundle exec rake routes:swagger:editor  # edit
```

## 💎 Installation

Add this line to your application's Gemfile:

```ruby
gem 'routes_to_swagger_docs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install routes_to_swagger_docs

## 🔦 Requirements

If you want to view with `Swagger UI` or edit with `Swagger Editor`, This gem needs the following:

- [`swaggerapi/swagger-ui:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-ui/)
- [`swaggerapi/swagger-editor:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-editor/)
- [`chromedriver`](http://chromedriver.chromium.org/downloads)

If you do not have it download as below.

```
$ docker pull swaggerapi/swagger-editor:latest
$ docker pull swaggerapi/swagger-ui:latest
$ brew cask install chromedriver
```

## 🚀 Tutorial

After requiring a gem,

```bash
bundle exec routes:swagger:docs
bundle exec routes:swagger:editor
```

## 📖 Usage

All settings are optional. The initial value is as follows.

In your rails project, Write `config/environments/development.rb` like that:

```ruby
# default setting
RoutesToSwaggerDocs.configure do |config|
  config.root_dir_path                      = "./swagger_docs"
  config.schema_save_dir_name               = "src"
  config.doc_save_file_name                 = "swagger_doc.yml"
  config.force_update_schema                = false
  config.use_tag_namespace                  = true
  config.use_schema_namespace               = false
  config.interval_to_save_edited_tmp_schema = 15

  config.server.data = [
    {
      url: "http://localhost:3000",
      description: "localhost"
    }
  ]

  config.swagger.configure do |swagger|
    swagger.ui.image            = "swaggerapi/swagger-ui"
    swagger.ui.port             = "8080"
    swagger.ui.exposed_port     = "8080/tcp"
    swagger.ui.volume           = "/app/swagger.json"
    swagger.editor.image        = "swaggerapi/swagger-editor"
    swagger.editor.port         = "81"
    swagger.editor.exposed_port = "8080/tcp" 
  end

  config.use_object_classes = {
    info_object:                    RoutesToSwaggerDocs::Schema::V3::InfoObject,
    paths_object:                   RoutesToSwaggerDocs::Schema::V3::PathsObject,
    path_item_object:               RoutesToSwaggerDocs::Schema::V3::PathItemObject,
    external_document_object:       RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject,
    components_object:              RoutesToSwaggerDocs::Schema::V3::ComponentsObject,
    components_schema_object:       RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject,
    components_request_body_object: RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  }

  config.http_statuses_when_http_method = {
    get: {
      default: %w(200 422),
      path_parameter: %w(200 404 422)
    },
    post: {
      default: %w(204 422),
      path_parameter: %w(204 404 422)
    },
    patch: {
      default: %w(204 422),
      path_parameter: %w(204 404 422)
    },
    put: {
      default: %w(204 422),
      path_parameter: %w(204 404 422)
    },
    delete: {
      default: %w(200 422),
      path_parameter: %w(200 404 422)
    }
  }

  config.http_methods_when_generate_request_body = %w[post patch put]

  config.tool.paths_stats.configure do |paths_stats|
    paths_stats.month_to_turn_to_warning_color = 3
    paths_stats.warning_color                  = :red
    paths_stats.table_title_color              = :yellow
    paths_stats.heading_color                  = :yellow
    paths_stats.highlight_color                = :magenta
  end

  # :dot or :underbar
  config.namespace_type = :underbar
end
```

You can execute the following command in the root directory of rails.

```bash
$ # Generate docs
$ bundle exec rake routes:swagger:docs                                                                        # Generate docs
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:docs    # Generate docs by specify unit paths

$ # Start swagger editor
$ bundle exec rake routes:swagger:editor                                                                      # Start swagger editor
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:editor  # Start swagger editor by specify unit paths
$ # Start swagger ui
$ bundle exec rake routes:swagger:ui                                                                          # Start swagger ui
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:ui      # Start swagger ui by specify unit paths
$ # Monitor swagger document
$ bundle exec rake routes:swagger:monitor                                                                     # Monitor swagger document
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:monitor # Monitor swagger by specify unit paths

$ # Analyze docs
$ SWAGGER_FILE="~/Desktop/swagger.yml" bundle exec rake routes:swagger:analyze
$ # Clean docs
$ bundle exec rake routes:swagger:clean
$ # Deploy docs
$ bundle exec rake routes:swagger:deploy

# Display paths list
$ bundle exec rake routes:swagger:paths_ls
# Display paths stats
$ bundle exec rake routes:swagger:paths_stats
```

## 📚 More Usage

- [How to generate docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_GENERATE_DOCS.md)
- [How to start swagger editor](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_EDITOR.md)
- [How to start swagger ui](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_UI.md)
- [How to monitor swagger document](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_MONITOR_SWAGGER_DOC.md)
- [How to analyze docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_ANALYZE_DOCS.md)
- [How to clean docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_CLEAN_DOCS.md)
- [How to deploy swagger doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DEPLOY_SWAGGER_DOC.md)
- [How to use tag namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_TAG_NAMESPACE.md)
- [How to use schema namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_SCHEMA_NAMESPACE.md)
- [How to use hook when generate doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_HOOK_WHEN_GENERATE_DOC.md)
- [How to display paths list](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DISPLAY_PATHS_LIST.md)
- [How to display paths stats](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DISPLAY_PATHS_STATS.md)

## ❤️ Support Rails Version

- Rails (>= 4.2.5.1)

## ❤️ Support Rouging

- Rails Engine Routing
- Rails Normal Routing

## ❤️ Support OpenAPI Schema

|version|document|
|-------|--------|
|v3|[versions/v3.md](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/versions/v3.md)|

## ❗️ Convention over Configuration (CoC)

- `tag name` represents `controller name` and determine `paths file name`.
  - For example, If `controller name` is `Api::V1::UsersController`, `tag_name` is `api/v1/user`. and `paths file name` is `api/v1/user.yml`

- `_` of `components/{schemas,requestBodies} name` convert `/` when save file.
  - For example, If `components/schemas name` is `Api_V1_User`, `components/schemas file name` is `api/v1/user.yml`.
  - `_` is supposed to be used to express `namespace`.

## ⚙ Configure

we explain the options that can be set.

#### basic

|option|description|default|
|------|-----------|---|
|root_dir_path|Root directory for storing products.| `"./swagger_docs"`
|schema_save_dir_name|Directory name for storing swagger schemas|`"src"`|
|doc_save_file_name|File name for storing swagger doc|`"swagger_doc.yml"`|
|force_update_schema|Force update schema from routes data|`false`|
|use_tag_namespace|Use namespace for tag name|`true`|
|use_schema_namespace|Use namespace for schema name|`true`|
|interval_to_save_edited_tmp_schema|Interval(sec) to save edited tmp schema|`15`|
|http_statuses_when_http_method|Determine the response to support for each HTTP method|omission...|
|http_methods_when_generate_request_body|HTTP methods when generate requestBody|`[post put patch]`|
|namespace_type|namespace for components(schemas/requestBodies) name| `underbar` |

#### server

|option|children option|description|default|
|------|---------------|-----------|-------|
|server|data|Server data (url, description) |[{ url: `http://localhost:3000`, description: `localhost` }] |

#### swagger

|option|children option|grandchild option|description|default|
|------|---------------|-----------------|-----------|-------|
|swagger|ui|image|Swagger UI Docker Image|`"swaggerapi/swagger-ui"`|
|swagger|ui|port|Swagger UI Port|`"8080"`|
|swagger|ui|exposed_port|Swagger UI Exposed Port|`"8080/tcp"`|
|swagger|ui|volume|Swagger UI Volume|`"/app/swagger.json"`|
|swagger|editor|image|Swagger Editor Docker Image|`"swaggerapi/swagger-editor"`|
|swagger|editor|port|Swagger Editor Port|`"8080"`|
|swagger|editor|exposed_port|Swagger Editor Exposed Port|`"8080/tcp"`|

#### hook

|option|description|default|
|------|-----------|-------|
|use_object_classes|Object class(hook class) to generate Openapi document|{ info_object: `RoutesToSwaggerDocs::Schema::V3::InfoObject`,<br>paths_object: `RoutesToSwaggerDocs::Schema::V3::PathsObject`,<br>path_item_object: `RoutesToSwaggerDocs::Schema::V3::PathItemObject`, external_document_object: `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`,<br> components_object: `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`,<br> components_schema_object: `RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject`, <br> components_request_body_object:`RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject` }|

#### tool

|option|children option|grandchild option|description|default|
|------|---------------|-----------------|-----------|-------|
|tool|paths_stats|month_to_turn_to_warning_color|Elapsed month to issue a warning|`3`|
|tool|paths_stats|warning_color|Warning Color|`:red`|
|tool|paths_stats|table_title_color|Table Title Color|`:yellow`|
|tool|paths_stats|heading_color|Heading Color|`:yellow`|
|tool|paths_stats|highlight_color|Highlight Color|`:magenta`|

Please refer to [here](https://github.com/janlelis/paint) for the color.

## Environment variables

We explain the environment variables that can be set.

|variable|description|default|
|--------|-----------|-------|
|UNIT_PATHS_FILE_PATH|Specify one schema path|`""`|
|SWAGGER_FILE|Specify swagger file to analyze|`""`|


## .paths

Writing file paths in .paths will only read them.
You can comment out with `#`

`swagger_docs/.paths`

```
#account_user_role.yml    # ignore
account.yml
account.yml               # ignore
account.yml               # ignore
```

## 💊 Life Cycle Methods (Hook Metohds)

Supported hook(life cycle methods) is like this:

- `before_create`
- `after_create`

Supported Hook class is like this:

- `RoutesToSwaggerDocs::Schema::V3::InfoObject`
- `RoutesToSwaggerDocs::Schema::V3::PathsObject`
- `RoutesToSwaggerDocs::Schema::V3::PathItemObject`
- `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`
- `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`
- `RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject`
- `RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject`

By inheriting these classes, you can hook them at the time of document generation by writing like this:

#### case: InfoObject

```ruby
class CustomInfoObject < RoutesToSwaggerDocs::Schema::V3::InfoObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, path|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathsObject

```ruby
class CustomPathsObject < RoutesToSwaggerDocs::Schema::V3::PathsObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathItemObject

```ruby
class CustomPathItemObject < RoutesToSwaggerDocs::Schema::V3::PathItemObject
  before_create do |doc, path|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

If you want to determine the component schema name at runtime, like this:

```ruby
class CustomPathItemObject < RoutesToSwaggerDocs::Schema::V3::PathItemObject
  def components_schema_name(doc, path_component, tag_name, verb, http_status, schema_name)
    # [Inportant] Please return string.
    # default
    schema_name
  end
end
```

#### case: ExternalDocumentObject

```ruby
class CustomExternalDocumentObject < RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: ComponentsObject

```ruby
class CustomComponentsObject < RoutesToSwaggerDocs::Schema::V3::ComponentsObject
  before_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: Components::SchemaObject

```ruby
class CustomComponentsSchemaObject < RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject
  before_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

If you want to determine the component schema name at runtime, like this:

```ruby
class CustomComponentsSchemaObject < RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject
  def components_schema_name(doc, path_component, tag_name, verb, http_status, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end
end
```

`path_component` is `RoutesToSwaggerDocs::Routing::PathComponent` instance.

```ruby
module RoutesToSwaggerDocs
  module Routing
    class PathComponent < BaseComponent
      def initialize(path)
      def to_s
      def symbol_to_brace
      def path_parameters_data
      def path_excluded_path_parameters
      def exist_path_parameters?
      def path_parameters
      private
      def without_format
```

#### case: Components::RequestBodyObject

```ruby
class CustomComponentsRequestBodyObject < RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  before_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [Important] Please change doc destructively.
    # [Important] To be able to use methods in Rails !
    doc.merge!({
      # Something ....
    })
  end
end
```

If you want to determine the component schema name at runtime, like this:

```ruby
class CustomComponentsRequestBodyObject < RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  def components_request_body_name(doc, path_component, tag_name, verb, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end

  def components_schema_name(doc, path_component, tag_name, verb, schema_name)
    # [Important] Please return string.
    # default
    schema_name
  end
end
```

And write this to the configuration.

```ruby
# If only InfoObject and PathItemObject, use a custom class
RoutesToSwaggerDocs.configure do |config|
  # 
  # omission ...
  # 
  config.use_object_classes.merge!({
    info_object:      CustomInfoObject,
    path_item_object: CustomPathItemObject
  })
end
```

This is the end.

## 🔩 CORS

If you use the online demo, make sure your API supports foreign requests by enabling CORS in Grape, otherwise you'll see the API description, but requests on the API won't return. Use [rack-cors](https://github.com/cyu/rack-cors) to enable CORS.

```ruby
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end
```

Alternatively you can set CORS headers in a Grape `before` block.

```ruby
before do
  header['Access-Control-Allow-Origin'] = '*'
  header['Access-Control-Request-Method'] = '*'
end
```

## 📝 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🤝 Contributing

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
