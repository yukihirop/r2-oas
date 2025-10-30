# Clean docs

Delete `components/schemas` and `components/requestBodies` files not in use.

## Prepare

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

## Command

```bash
$ bundle exec rake routes:oas:clean
```
