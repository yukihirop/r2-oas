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

## Command

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

## Usage

- [How to generate docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_GENERATE_DOCS.md)
- [How to start swagger editor](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_EDITOR.md)
- [How to start swagger ui](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_UI.md)
- [How to analyze docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_ANALYZE_DOCS.md)
- [How to deploy swagger doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DEPLOY_SWAGGER_DOC.md)
- [How to use tag namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_TAG_NAMESPACE.md)
- [How to use schema namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_SCHEMA_NAMESPACE.md)

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

|option|description|default|
|------|-----------|---|
|root_dir_path|Root directory for storing products.| `"./swagger_docs"`
|schema_save_dir_name|Directory name for storing swagger schemas|`"shcemas"`|
|doc_save_file_name|File name for storing swagger doc|`"swagger_doc.yml"`|
|force_update_schema|Force update schema from routes data|`false`|
|use_tag_namespace|Use namespace for tag name|`true`|
|use_schema_namespace|Use namespace for schema name|`true`|
|server.url| Server url | `http://localhost:3000` |
|server.description| Server description | `localhost` |

## Environment variables

We explain the environment variables that can be set.

|variable|description|default|
|--------|-----------|-------|
|UNIT_PATHS_FILE_PATH|Specify one schema path|`""`|
|SWAGGER_FILE|Specify swagger file to analyze|`""`|

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
