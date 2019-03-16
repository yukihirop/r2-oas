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

## Usage

```ruby

require 'routes_to_swagger_docs

RoutesToSwaggerDocs.configure do |config|
   # default setting        
   config.root_dir_path = "./swagger_docs"
   config.schema_save_dir_path = "./swagger_docs/shemas"
   config.doc_save_file_path = "./swagger_docs/swagger_doc.yml"
end
```

## Support Rails Version

- Rails 4.2.5.1

## Configure

we explain the options that can be set.

|option|description|default|
|------|-----------|---|
|root_dir_path|Root directory for storing products.|"./swagger_docs"
|schema_save_dir_path|Directory for storing swagger schemas|"./swagger_docs/shcemas"|
|doc_save_file_path|Directory for storing swagger doc|"./swagger_docs/swagger_doc.yml"|


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request