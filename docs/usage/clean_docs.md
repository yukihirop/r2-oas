---
layout: default
title: Clean Docs
permalink: "/usage/clean-docs/"
parent: Usage
nav_order: 15
---

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
