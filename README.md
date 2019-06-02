# RoutesToSwaggerDocs

Generate swagger docs (side only) from rails routing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'routes_to_swagger_docs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install routes_to_swagger_docs

## Requirements

This gem needs the following:

- [`swaggerapi/swagger-ui:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-ui/)
- [`swaggerapi/swagger-editor:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-editor/)
- [`chromedriver`](http://chromedriver.chromium.org/downloads)

If you do not have it download as below.

```
$ docker pull swaggerapi/swagger-editor:latest
$ docker pull swaggerapi/swagger-ui:latest
$ brew cask install chromedriver
```

## Usage

In your rails project, Write `config/environments/development.rb` like that:

```ruby
# default setting
RoutesToSwaggerDocs.configure do |config|
  config.root_dir_path = "./swagger_docs"
  config.schema_save_dir_name = "schema"
  config.doc_save_file_name = "swagger_doc.yml"
  config.force_update_schema = false
  config.use_tag_namespace = true
  config.use_schema_namespace = false
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
    info_object:              RoutesToSwaggerDocs::Schema::V3::InfoObject,
    paths_object:             RoutesToSwaggerDocs::Schema::V3::PathsObject,
    path_item_object:         RoutesToSwaggerDocs::Schema::V3::PathItemObject,
    external_document_object: RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject,
    components_object:        RoutesToSwaggerDocs::Schema::V3::ComponentsObject,
    schema_object:            RoutesToSwaggerDocs::Schema::V3::SchemaObject
  }
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
$ # Analyze docs
$ SWAGGER_FILE="~/Desktop/swagger.yml" bundle exec rake routes:swagger:analyze
$ # Deploy docs
$ bundle exec rake routes:swagger:deploy
```

## More Usage

- [How to generate docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_GENERATE_DOCS.md)
- [How to start swagger editor](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_EDITOR.md)
- [How to start swagger ui](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_UI.md)
- [How to analyze docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_ANALYZE_DOCS.md)
- [How to deploy swagger doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DEPLOY_SWAGGER_DOC.md)
- [How to use tag namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_TAG_NAMESPACE.md)
- [How to use schema namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_SCHEMA_NAMESPACE.md)
- [How to use hook when generate doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_HOOK_WHEN_GENERATE_DOC.md)

## Support Rails Version

- Rails 4.2.5.1

## Support Rouging

- Rails Engine Routing
- Rails Normal Routing

## Support OpenAPI Schema

|version|document|
|-------|--------|
|v3|[versions/v3.md](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/versions/v3.md)|

## Configure

we explain the options that can be set.

#### basic

|option|description|default|
|------|-----------|---|
|root_dir_path|Root directory for storing products.| `"./swagger_docs"`
|schema_save_dir_name|Directory name for storing swagger schemas|`"shcemas"`|
|doc_save_file_name|File name for storing swagger doc|`"swagger_doc.yml"`|
|force_update_schema|Force update schema from routes data|`false`|
|use_tag_namespace|Use namespace for tag name|`true`|
|use_schema_namespace|Use namespace for schema name|`true`|
|interval_to_save_edited_tmp_schema|Interval(sec) to save edited tmp schema|`15`|

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
|use_object_classes|Object class(hook class) to generate Openapi document|{ info_object: `RoutesToSwaggerDocs::Schema::V3::InfoObject`,<br>paths_object: `RoutesToSwaggerDocs::Schema::V3::PathsObject`,<br>path_item_object: `RoutesToSwaggerDocs::Schema::V3::PathItemObject`, external_document_object: `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`,<br> components_object: `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`,<br> schema_object: `RoutesToSwaggerDocs::Schema::V3::SchemaObject` }|

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

## Life Cycle Methods (Hook Metohds)

Supported hook(life cycle methods) is like this:

- `before_create`
- `after_create`

Supported Hook class is like this:

- `RoutesToSwaggerDocs::Schema::V3::InfoObject`
- `RoutesToSwaggerDocs::Schema::V3::PathsObject`
- `RoutesToSwaggerDocs::Schema::V3::PathItemObject`
- `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`
- `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`
- `RoutesToSwaggerDocs::Schema::V3::SchemaObject`

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

#### case: SchemaObject

```ruby
class CustomSchemaObject < RoutesToSwaggerDocs::Schema::V3::SchemaObject
  before_create do |doc, schema_name|
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

## CORS

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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
