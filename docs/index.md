---
layout: default
title: R2-OAS Documentation
nav_order: 1
permalink: "/"
---

[![Gem Version](https://badge.fury.io/rb/r2-oas.svg)](https://badge.fury.io/rb/r2-oas)
[![Build Status](https://travis-ci.org/yukihirop/r2-oas.svg?branch=master)](https://travis-ci.org/yukihirop/r2-oas)
[![Coverage Status](https://coveralls.io/repos/github/yukihirop/r2-oas/badge.svg)](https://coveralls.io/github/yukihirop/r2-oas)
[![Maintainability](https://api.codeclimate.com/v1/badges/f8c3846f350bb412fd63/maintainability)](https://codeclimate.com/github/yukihirop/r2-oas/maintainability)

<p align="center">
	<img alt="logo" width="196" src="https://raw.githubusercontent.com/yukihirop/r2-oas/master/docs/assets/logo.png">
</p>

<h1 align="center" style="font-family: sans-serif; font-size: 50px; font-weight: 700; background: -webkit-linear-gradient(90deg, #CC342D 20%, #E63D36 60%, #FF5C55 100%); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent; color: transparent;">R2-OAS</h1>

<p align="center">
	<a href="https://yukihirop.github.io/r2-oas/" target="_blank">📚 Documentation</a>
</p>

Generate api document (OpenAPI) side only from `Rails` routing.

Provides a rake command to help `generate`, `view`, and `edit` OpenAPI documents.

```bash
bundle exec rake routes:oas:init    # r2-oas initialize
bundle exec rake routes:oas:docs    # generate oas_docs
bundle exec rake routes:oas:ui      # view at swagger ui
bundle exec rake routes:oas:editor  # edit at swagger editor
bundle exec rake routes:oas:monitor # monitor oas_docs and analyze
bundle exec rake routes:oas:build   # build oas_docs from src
bundle exec rake routes:oas:clean   # clean unused components
bundle exec rake routes:oas:analyze # analyze oas_docs and generae src
bundle exec rake routes:oas:deploy  # deploy oas_docs to deploy_docs
```

## 💎 Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'r2-oas'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install r2-oas

## 🔦 Requirements

If you want to view with `Swagger UI` or edit with `Swagger Editor`, This gem needs the following:

- [`swaggerapi/swagger-ui:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-ui/)
- [`swaggerapi/swagger-editor:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-editor/)
- [`chromedriver`](http://chromedriver.chromium.org/downloads)

If you do not have it download as below.

```
$ docker pull swaggerapi/swagger-editor:latest
$ docker pull swaggerapi/swagger-ui:latest
$ brew install chromedriver
```

## 🚀 Tutorial

After requiring a gem and Configure `Rakefile` in your rails project

```rb
R2OAS.load_tasks
```

```bash
$ bundle exec rake routes:oas:init
      create	oas_docs
      create	oas_docs/.paths
      create	oas_docs/plugins/helpers
      create	oas_docs/tasks/helpers
      create	oas_docs/plugins/.gitkeep
      create	oas_docs/plugins/helpers/.gitkeep
      create	oas_docs/tasks/.gitkeep
      create	oas_docs/tasks/helpers/.gitkeep
$ bundle exec rake routes:oas:docs
$ bundle exec rake routes:oas:editor
```

#### Generate docs

<p align="center">
	<img alt="r2-oas docs demo" width="800" src="https://raw.githubusercontent.com/yukihirop/r2-oas/master/demo/oas_docs.mp4">
</p>

#### Edit docs

<p align="center">
	<img alt="r2-oas editor demo" width="800" src="https://raw.githubusercontent.com/yukihirop/r2-oas/master/demo/oas_editor.mp4">
</p>

## Usage

You can execute the following command in the root directory of rails.  
The following are examples of typical command usage.

Full docs are available at https://yukihirop.github.io/r2-oas

### Initialize

Initialize r2-oas.

```bash
$ bundle exec rake routes:oas:init
      create	oas_docs
      create	oas_docs/.paths
      create	oas_docs/plugins/helpers
      create	oas_docs/tasks/helpers
      create	oas_docs/plugins/.gitkeep
      create	oas_docs/plugins/helpers/.gitkeep
      create	oas_docs/tasks/.gitkeep
      create	oas_docs/tasks/helpers/.gitkeep
```

### Generate

Generate docs.

```bash
$ bundle exec rake routes:oas:docs                                                       # Generate docs
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:docs    # Generate docs by specify unit paths
```

### Editor

Start Swagger editor.

```bash
$ bundle exec rake routes:oas:editor                                                     # Start swagger editor
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:editor  # Start swagger editor by specify unit paths
```

### UI

Start swagger ui.

```bash
$ bundle exec rake routes:oas:ui                                                         # Start swagger ui
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:ui      # Start swagger ui by specify unit paths
```

### Build

Build docs.  
`Plugin is applied`

```bash
$ bundle exec rake routes:oas:build
```

### Analyze

Analyze docs.  
Reads OpenAPI format document and divides it into several parts to generate a source file

```bash
$ OAS_FILE="~/Desktop/swagger.yml" bundle exec rake routes:oas:analyze
```

## 📚 Documents

Full docs are available at https://yukihirop.github.io/r2-oas

## ❤️ Support Rails Version

- Rails 7.2.2.2
- Rails (>= 8.x)

## ❤️ Support Ruby Version

- Ruby 3.2.6
- Ruby 3.3.6
- Ruby (>= 3.4.x)

## ❤️ Support Rouging

- Rails Engine Routing
- Rails Normal Routing

## ❤️ Support OpenAPI Schema

Full docs are available at https://yukihirop.github.io/r2-oas/#/schema/3.0.0

## ❗️ Convention over Configuration (CoC)

- `tag name` represents `controller name` and determines `paths file name`.
  - For example, If `controller name` is `Api::V1::UsersController`, `tag_name` is `api/v1/user`, then `paths file name` is `api/v1/user.yml`

- `_` of `components/{schemas,requestBodies, ...} name` convert `/` when save file.
  - For example, If `components/schemas name` is `Api_V1_User`, `components/schemas file name` is `api/v1/user.yml`.
  - `_` is supposed to be used to express `namespace`.
  - format is `Namespace1_Namespace2_Model`.

- `.` of `components/{schemas,requestBodies, ...} name` convert `/` when saving the file.
  - For example, If `components/schemas name` is `api.v1.User`, `components/schemas file name` is `api/v1/user.yml`.
  - `.` is supposed to be used to express `namespace`.
  - format is `namespace1.namespace2.Model`.

## ⚙ Configure

All settings are `optional`

Full docs are available at https://yukihirop.github.io/r2-oas/#/setting/configure

## Bundle and Rspec with multiple ruby ​​versions

#### Bundle

```bash
/bin/bash devscript/all_support_ruby.sh bundle
.
.
.
===== Bundle install for All Support Ruby Result =====
ruby-3.2.6: 0
ruby-3.3.6: 0
ruby-3.4.7: 0
======================================================
```

If specify ruby version `3.2.6` and `3.3.6`

```bash
/bin/bash devscript/all_support_ruby.sh bundle 3.2.6 3.3.6
.
.
.
===== Bundle install for All Support Ruby Result =====
ruby-3.2.6: 0
ruby-3.3.6: 0
======================================================
```

#### Rspec

```bash
/bin/bash devscript/all_support_ruby.sh rspec
.
.
.
===== Rspec for All Support Ruby Result =====
ruby-3.2.6: 0
ruby-3.3.6: 0
ruby-3.4.7: 0
=============================================
```

If specify ruby version `3.2.6` and `3.3.6`

```bash
/bin/bash devscript/all_support_ruby.sh rspec 3.2.6 3.3.6
.
.
.
===== Rspec for All Support Ruby Result =====
ruby-3.2.6: 0
ruby-3.3.6: 0
=============================================
```

## 🔩 CORS

Use [rack-cors](https://github.com/cyu/rack-cors) to enable CORS.

```ruby
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end
```

Alternatively, you can set CORS headers in a `before` block.

```ruby
before do
  header['Access-Control-Allow-Origin'] = '*'
  header['Access-Control-Request-Method'] = '*'
end
```

## 📝 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🤝 Contributing

1. Fork it ( http://github.com/yukihirop/r2-oas/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
