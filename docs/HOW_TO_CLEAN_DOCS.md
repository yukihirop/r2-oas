## Basic Usage

Delete `components/schemas` and `components/requestBodies` files not in use.

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
$ bundle exec rake routes:oas:clean
```
