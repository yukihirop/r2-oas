
# Display paths list

## Prepare

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

## Comamnd

```
$ bundle exec rake routes:oas:paths_ls
```

## Example

```bash
$ bundle exec rake routes:oas:paths_ls
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/user.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account_user_role.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/user.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/account.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/task.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v1/post.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/custom_post.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/api/v2/post.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/task.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/engine.yml
/Users/yukihirop/RubyProjects/r2-oas/oas_docs/src/paths/rails_admin/main.yml
```
