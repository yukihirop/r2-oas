# R2-OAS

[![Gem Version](https://badge.fury.io/rb/r2-oas.svg)](https://badge.fury.io/rb/r2-oas)
[![Build Status](https://travis-ci.org/yukihirop/r2-oas.svg?branch=master)](https://travis-ci.org/yukihirop/r2-oas)
[![Coverage Status](https://coveralls.io/repos/github/yukihirop/r2-oas/badge.svg)](https://coveralls.io/github/yukihirop/r2-oas)
[![Maintainability](https://api.codeclimate.com/v1/badges/f8c3846f350bb412fd63/maintainability)](https://codeclimate.com/github/yukihirop/r2-oas/maintainability)

Railsのルーティング情報からOpenAPI形式のドキュメントを生成し、閲覧・編集・管理するためのrakeタスクの提供をします。

```bash
bundle exec rake routes:oas:init    # 初期化
bundle exec rake routes:oas:docs    # ドキュメント生成
bundle exec rake routes:oas:ui      # ドキュメント閲覧
bundle exec rake routes:oas:editor  # ドキュメント編集
bundle exec rake routes:oas:monitor # ドキュメント監視
bundle exec rake routes:oas:build   # ドキュメントビルド
bundle exec rake routes:oas:clean   # ドキュメント清掃
bundle exec rake routes:oas:analyze # ドキュメント分解・分析
bundle exec rake routes:oas:deploy  # ドキュメントデプロイ
```

## 💎 Installation

railsアプリケーションのGemfileに以下を追加します。

```ruby
group :development do
  gem 'r2-oas'
end
```

## 🔦 Requirements

もしSwaggerEditorやSwaggerUIを使ってドキュメントを閲覧・編集する場合には以下のものが必要です。

- [`swaggerapi/swagger-ui:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-ui/)
- [`swaggerapi/swagger-editor:latest` docker image](https://hub.docker.com/r/swaggerapi/swagger-editor/)
- [`chromedriver`](http://chromedriver.chromium.org/downloads)

もしダウンロードしてなかったら以下のコマンドでダウンロードできます。

```
$ docker pull swaggerapi/swagger-editor:latest
$ docker pull swaggerapi/swagger-ui:latest
$ brew cask install chromedriver
```

## 🚀 Tutorial

gemをrequire後、以下のrakeタスクを実行するだけです。

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

![oas_docs](https://user-images.githubusercontent.com/11146767/80856236-0b839a80-8c83-11ea-888f-d0e659e0c251.gif)


#### Edit docs

![oas_editor](https://user-images.githubusercontent.com/11146767/80856240-15a59900-8c83-11ea-9dbd-4382528944f2.gif)

## 📚 Documents

公式ドキュメントはこちら => https://yukihirop.github.io/r2-oas

## 📖 Usage


railsプロジェクトのルートディレクトリで以下のコマンドが実行可能です。  
一般的なコマンドの使用例を示します。

### Initialize

`r2-oas`の初期化

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

ドキュメントの生成

```bash
$ bundle exec rake routes:oas:docs                                                       # Generate docs
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:docs    # Generate docs by specify unit paths
```

### Editor

SwaggerEditorの起動

```bash
$ bundle exec rake routes:oas:editor                                                     # Start swagger editor
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:editor  # Start swagger editor by specify unit paths
```

### UI

SwaggerUIの起動

```bash
$ bundle exec rake routes:oas:ui                                                         # Start swagger ui
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:ui      # Start swagger ui by specify unit paths
```

### Build

ドキュメントのビルド  
※プラグインが適用されます。

```bash
$ bundle exec rake routes:oas:build
```

### Analyze

ドキュメントの分割   
OpenAPI形式のドキュメントを読み取り、それをいくつかの部分に分割してソースファイルを生成します

```bash
$ OAS_FILE="~/Desktop/swagger.yml" bundle exec rake routes:oas:analyze
```

## ⚾️ sample

実際の使用例を見るにはこちらのリポジトリを参考にしてください。

- [yukihirop/r2oas-k8s-example](https://github.com/yukihirop/r2oas-k8s-example)
- [yukihirop/r2oas-moneyforward-example](https://github.com/yukihirop/r2oas-moneyforward-example)
- [yukihirop/r2oas-leaddesk-example](https://github.com/yukihirop/r2oas-leaddesk-example)
- [yukihirop/r2oas-advanced-example](https://github.com/yukihirop/r2oas-advanced-example)

## ❤️ Support Rails Version

- Rails (>= 4.2.5.1)

## ❤️ Support Ruby Version

- Ruby (>= 2.5.0)

## ❤️ Support Rouging

- Rails Engine Routing
- Rails Normal Routing

## ❤️ Support OpenAPI Schema

OpenAPIの3.0.0をサポートしてます。

公式ドキュメントはこちら => https://yukihirop.github.io/r2-oas/#/schema/3.0.0

## ❗️Convention over Configuration (CoC)

ツールを便利にするために、設定よりも制約があります。

- `タグ名` は `コントローラー名` を表しており、`pathsファイル名とパス` を決定するのに使用されます。
  - 例えば、 `コントローラー名` が `Api::V1::UsersController` ならば、 `タグ名` は `api/v1/user` になります。そして、 `pathsファイル名とパス` は `api/v1/user.yml` となります。

- `components/{schemas, requestBodies, ...}名` の `_` は保存時に `/` に変換されます。hennkannsaremasu.
  - 例えば、 `components/schemas名` が `Api_V1_User` なら、 `components/schemasのファイル名とパス` は `api/v1/user.yml` となります。
  - フォーマットは、 `Namespace1_Namespace2_Model` です。

- `components/{schemas, requestBodies, ...}名` の `.` は保存時に `/` に変換されます。hennkannsaremasu.
  - 例えば、 `components/schemas名` が `api.v1.User` なら、 `components/schemasのファイル名とパス` は `api/v1/user.yml` となります。
  - フォーマットは、 `namespace1.namespace2.Model` です。

## ⚙ Configure

全ての設定は `オプショナル` です。設定してもしなくても構いません。

公式ドキュメントはこちら => https://yukihirop.github.io/r2-oas/#/setting/configure

## Bundle and Rspec with multiple ruby ​​versions

#### Bundle

```bash
/bin/bash devscript/all_support_ruby.sh bundle
.
.
.
===== Bundle install for All Support Ruby Result =====
ruby-2.6.10: 0
ruby-2.7.8: 0
======================================================
```

rubyのバージョンを `2.6.10` と `2.7.8`　に指定する場合

```bash
/bin/bash devscript/all_support_ruby.sh bundle 2.6.10 2.7.8
.
.
.
===== Bundle install for All Support Ruby Result =====
ruby-2.6.10: 0
ruby-2.7.8: 0
======================================================
```

#### Rspec

```bash
/bin/bash devscript/all_support_ruby.sh rspec
.
.
.
===== Rspec for All Support Ruby Result =====
ruby-2.6.10: 0
ruby-2.7.8: 0
=============================================
```

rubyのバージョンを `2.6.10` と `2.7.8`　に指定する場合

```bash
/bin/bash devscript/all_support_ruby.sh rspec 2.6.10 2.7.8
.
.
.
===== Rspec for All Support Ruby Result =====
ruby-2.6.10: 0
ruby-2.7.8: 0
=============================================
```

## 🔩 CORS

[rack-cors](https://github.com/cyu/rack-cors)を使用する事でCORSを可能にします。

```ruby
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end
```

`before` ブロックにCORSヘッダーを設定できます。

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
