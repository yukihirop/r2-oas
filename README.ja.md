# R2-OAS

[![Gem Version](https://badge.fury.io/rb/r2-oas.svg)](https://badge.fury.io/rb/r2-oas)
[![Build Status](https://travis-ci.org/yukihirop/r2-oas.svg?branch=master)](https://travis-ci.org/yukihirop/r2-oas)
[![Coverage Status](https://coveralls.io/repos/github/yukihirop/r2-oas/badge.svg)](https://coveralls.io/github/yukihirop/r2-oas)
[![Maintainability](https://api.codeclimate.com/v1/badges/f8c3846f350bb412fd63/maintainability)](https://codeclimate.com/github/yukihirop/r2-oas/maintainability)

Railsのルーティング情報からOpenAPI形式のドキュメントを生成し、閲覧・編集・管理するためのrakeタスクの提供をします。

```bash
bundle exec rake routes:oas:docs    # ドキュメント生成
bundle exec rake routes:oas:ui      # ドキュメント閲覧
bundle exec rake routes:oas:editor  # ドキュメント編集
bundle exec rake routes:oas:monitor # ドキュメント監視
bundle exec rake routes:oas:dist    # ドキュメント配布
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
bundle exec routes:oas:docs
bundle exec routes:oas:editor
```

#### Generate docs

![oas_docs](https://user-images.githubusercontent.com/11146767/79999059-6e906700-84f6-11ea-818c-30d9fdfeafb6.gif)


#### Edit docs

![oas_editor](https://user-images.githubusercontent.com/11146767/79999041-69cbb300-84f6-11ea-99b6-f454b6baa3ee.gif)

## 📚 Documents

公式ドキュメントはこちら => https://yukihirop.github.io/r2-oas

## 📖 Usage

railsプロジェクトのルートディレクトリで以下のコマンドが実行可能です。

```bash
$ # ドキュメント生成
$ bundle exec rake routes:oas:docs
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:docs    # pathsファイルを指定してドキュメント生成

$ # SwaggerEditorでドキュメント編集
$ bundle exec rake routes:oas:editor
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:editor  # pathsファイルを指定してドキュメント編集
$ # SwaggerUIでドキュメント閲覧
$ bundle exec rake routes:oas:ui
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:ui      # pathsファイルを指定してドキュメント閲覧
$ # テキストエディタでドキュメント編集(初期設定時、git管理しないoas_docs/oas_doc.ymlを監視)
$ bundle exec rake routes:oas:monitor
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:monitor # pathsファイルを指定してドキュメント監視

$ # ドキュメントを分解・分析
$ OAS_FILE="~/Desktop/swagger.yml" bundle exec rake routes:oas:analyze
$ # どこからも参照されてないcomponents/schemas(requestBodies, ...)を削除
$ bundle exec rake routes:oas:clean
$ # githubにホスティング
$ bundle exec rake routes:oas:deploy
$ # ドキュメントを配布(初期設定時、配布ファイルは、oas_docs/oas_doc.yml)
$ bundle exec rake routes:oas:dist
$ PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:dist    # pathsファイルを指定してドキュメント配布
 
# pathsファイルのリスト取得
$ bundle exec rake routes:oas:paths_ls
# pathsファイルの編集履歴表示
$ bundle exec rake routes:oas:paths_stats
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

- Ruby (>= 2.3.3p222 (2016-11-21 revision 56859) [x86_64-darwin18])

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

## 💊 Life Cycle Methods (Hook Metohds)

ドキュメント生成時に、フックを可能にするメソッドを用意しております。

公式ドキュメントはこちら => https://yukihirop.github.io/r2-oas/#/usage/use_hook_methods

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
