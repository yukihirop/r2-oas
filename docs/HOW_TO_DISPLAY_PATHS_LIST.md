## Basic Usage

```ruby

require 'routes_to_swagger_docs'

RoutesToSwaggerDocs.configure do |config|
   # default setting        
   config.root_dir_path = "./swagger_docs"
   config.schema_save_dir_name = "shemas"
   config.doc_save_file_name = "swagger_doc.yml"
end
```

```bash
$ bundle exec rake routes:swagger:paths_ls
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/user.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v1/account_user_role.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v1/user.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v1/account.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v1/task.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v1/post.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v2/custom_post.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/api/v2/post.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/task.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/rails_admin/engine.yml
/Users/yukihirop/RubyProjects/routes_to_swagger_docs/swagger_docs/schema/paths/rails_admin/main.yml
```
