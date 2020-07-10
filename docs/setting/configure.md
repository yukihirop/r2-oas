## Configure

All settings are `optional`. The initial value is as follows.

In your rails project, Write `config/environments/development.rb` like that:

```ruby
# default setting
R2OAS.configure do |config|
  config.version                            = :v3
  config.root_dir_path                      = "./oas_docs"
  config.schema_save_dir_name               = "src"
  config.doc_save_file_name                 = "oas_doc.yml"
  config.force_update_schema                = false
  config.use_tag_namespace                  = true
  config.use_schema_namespace               = false
  config.interval_to_save_edited_tmp_schema = 15
  # :dot or :underbar
  config.namespace_type                     = :dot
  config.deploy_dir_path                    = "./deploy_docs"

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
    info_object:                    R2OAS::Schema::V3::InfoObject,
    paths_object:                   R2OAS::Schema::V3::PathsObject,
    path_item_object:               R2OAS::Schema::V3::PathItemObject,
    external_document_object:       R2OAS::Schema::V3::ExternalDocumentObject,
    components_object:              R2OAS::Schema::V3::ComponentsObject,
    components_schema_object:       R2OAS::Schema::V3::Components::SchemaObject,
    components_request_body_object: R2OAS::Schema::V3::Components::RequestBodyObject
  }

  config.http_statuses_when_http_method = {
    get: {
      default: %w(200 422),
      path_parameter: %w(200 404 422)
    },
    post: {
      default: %w(201 422),
      path_parameter: %w(201 404 422)
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
  config.ignored_http_statuses_when_generate_component_schema = %w[204 404]

  config.tool.paths_stats.configure do |paths_stats|
    paths_stats.month_to_turn_to_warning_color = 3
    paths_stats.warning_color                  = :red
    paths_stats.table_title_color              = :yellow
    paths_stats.heading_color                  = :yellow
    paths_stats.highlight_color                = :magenta
  end
end
```

we explain the options that can be set.

#### basic

|option|description|default|
|------|-----------|---|
|version|OpenAPI schema version| `:v3` |
|root_dir_path|Root directory for storing products.| `"./oas_docs"` |
|schema_save_dir_name|Directory name for storing swagger schemas|`"src"`|
|doc_save_file_name|File name for storing swagger doc|`"oas_doc.yml"`|
|force_update_schema|Force update schema from routes data|`false`|
|use_tag_namespace|Use namespace for tag name|`true`|
|use_schema_namespace|Use namespace for schema name|`true`|
|interval_to_save_edited_tmp_schema|Interval(sec) to save edited tmp schema|`15`|
|http_statuses_when_http_method|Determine the response to support for each HTTP method|omission...|
|http_methods_when_generate_request_body|HTTP methods when generate requestBody|`[post put patch]`|
|ignored_http_statuses_when_generate_component_schema|Ignore HTTP statuses when generate component schema|`[204 404]`|
|namespace_type|namespace for components(schemas/requestBodies) name| `dot` |
|deploy_dir_path|deploy directory.|`"./deploy_docs"`|

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
|use_object_classes|Object class(hook class) to generate Openapi document|{ info_object: `R2OAS::Schema::V3::InfoObject`,<br>paths_object: `R2OAS::Schema::V3::PathsObject`,<br>path_item_object: `R2OAS::Schema::V3::PathItemObject`, external_document_object: `R2OAS::Schema::V3::ExternalDocumentObject`,<br> components_object: `R2OAS::Schema::V3::ComponentsObject`,<br> components_schema_object: `R2OAS::Schema::V3::Components::SchemaObject`, <br> components_request_body_object:`R2OAS::Schema::V3::Components::RequestBodyObject` }|

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
|PATHS_FILE|Specify one paths file path|`""`|
|OAS_FILE|Specify swagger file path to analyze|`""`|
|CACHE_DOCS|Effective only when there is no `.docs` file. Specifying `true` will generate a` .docs` file when the `routes:oas:docs` command is executed.|`false`|


## .paths

Writing file paths in .paths will only read them.
You can comment out with `#`

`oas_docs/.paths`

```
#account_user_role.yml    # ignore
account.yml
account.yml               # ignore
account.yml               # ignore
```

## .docs

It holds the information in the current routing as a cache. Thanks to this, when the `routes:oas:docs` command is executed, changes in routing can be detected and appropriate processing can be performed.

If you want to inspect `.docs`. You can check it by entering the following code with `pry` or something.

```ruby
result = IO.binread("oas_docs/.docs")
inflate = Zlib::Inflate.inflate(result)
puts Marshal.load(inflate)
```
