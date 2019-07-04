## Basic Usage

Delete `components/schemas` and `components/requestBodies` files not in use.

```ruby

require 'routes_to_swagger_docs'

RoutesToSwaggerDocs.configure do |config|
   # default setting        
   config.root_dir_path        = "./swagger_docs"
   config.schema_save_dir_name = "src"
   config.doc_save_file_name   = "swagger_doc.yml"
end
```

```bash
$ bundle exec rake routes:swagger:clean
```
