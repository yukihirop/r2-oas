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
# Generate docs
$ bundle exec rake routes:swagger:docs                                                                        # Generate docs
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:docs    # Generate docs by specify unit paths
# Start swagger editor
$ bundle exec rake routes:swagger:editor                                                                      # Start swagger editor
$ UNIT_PATHS_FILE_PATH="../swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:editor  # Start swagger editor by specify unit paths
```

## Usage

- [How to generate docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_GENERATE_DOCS.md)
- [How to start swagger editor](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_EDITOR.md)

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
|root_dir_path|Root directory for storing products.|"./swagger_docs"
|schema_save_dir_name|Directory name for storing swagger schemas|"shcemas"|
|doc_save_file_name|File name for storing swagger doc|"swagger_doc.yml"|

## Environment variables

We explain the environment variables that can be set.




## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request