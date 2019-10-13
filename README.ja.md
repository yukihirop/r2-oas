# RoutesToSwaggerDocs

railsのルーティング情報からOpenAPI(V3)形式のドキュメントを生成し、閲覧・編集・管理するためのrakeタスクの提供をします。

```bash
bundle exec rake routes:swagger:docs    # ドキュメント生成
bundle exec rake routes:swagger:ui      # ドキュメント閲覧
bundle exec rake routes:swagger:editor  # ドキュメント編集
bundle exec rake routes:swagger:monitor # ドキュメント監視
bundle exec rake routes:swagger:dist    # ドキュメント配布
bundle exec rake routes:swagger:clean   # ドキュメント清掃
bundle exec rake routes:swagger:analyze # ドキュメント分解・分析
bundle exec rake routes:swagger:deploy  # ドキュメントデプロイ
```

## 💎 Installation

railsアプリケーションのGemfileに以下を追加します。

```ruby
group :development do
  gem 'routes_to_swagger_docs'
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
bundle exec routes:swagger:docs
bundle exec routes:swagger:editor
```

## 📖 Usage

全ての設定は `オプショナル` です。設定してもしなくても構いません。

設定はrailsプロジェクトの `config/environments/development.rb` に書きます。

デフォルトでは以下に設定されています。

```ruby
# default setting
RoutesToSwaggerDocs.configure do |config|
  config.version                            = :v3
  #「docs」という名前は使えません。予約語です。
  config.root_dir_path                      = "./swagger_docs"
  config.schema_save_dir_name               = "src"
  config.doc_save_file_name                 = "swagger_doc.yml"
  config.force_update_schema                = false
  config.use_tag_namespace                  = true
  config.use_schema_namespace               = false
  config.interval_to_save_edited_tmp_schema = 15

  config.server.data = [
    {
      url: "http://localhost:3000",
      description: "localhost"
    }
  ]

  config.swagger.configure do |swagger|
    swagger.ui.image            = "swaggerapi/swagger-ui"
    swagger.ui.port             = "8080"
    swagger.ui.exposed_port     = "8080/tcp"
    swagger.ui.volume           = "/app/swagger.json"
    swagger.editor.image        = "swaggerapi/swagger-editor"
    swagger.editor.port         = "81"
    swagger.editor.exposed_port = "8080/tcp" 
  end

  config.use_object_classes = {
    info_object:                    RoutesToSwaggerDocs::Schema::V3::InfoObject,
    paths_object:                   RoutesToSwaggerDocs::Schema::V3::PathsObject,
    path_item_object:               RoutesToSwaggerDocs::Schema::V3::PathItemObject,
    external_document_object:       RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject,
    components_object:              RoutesToSwaggerDocs::Schema::V3::ComponentsObject,
    components_schema_object:       RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject,
    components_request_body_object: RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  }

  config.http_statuses_when_http_method = {
    get: {
      default: %w(200 422),
      path_parameter: %w(200 404 422)
    },
    post: {
      default: %w(201 422),
      path_parameter: %w(201 404 422)
    },
    patch: {
      default: %w(204 422),
      path_parameter: %w(204 404 422)
    },
    put: {
      default: %w(204 422),
      path_parameter: %w(204 404 422)
    },
    delete: {
      default: %w(200 422),
      path_parameter: %w(200 404 422)
    }
  }

  config.http_methods_when_generate_request_body = %w[post patch put]

  config.tool.paths_stats.configure do |paths_stats|
    paths_stats.month_to_turn_to_warning_color = 3
    paths_stats.warning_color                  = :red
    paths_stats.table_title_color              = :yellow
    paths_stats.heading_color                  = :yellow
    paths_stats.highlight_color                = :magenta
  end

  # :dot or :underbar
  config.namespace_type = :underbar
end
```

railsプロジェクトのルートディレクトリで以下のコマンドが実行可能です。

```bash
$ # ドキュメント生成
$ bundle exec rake routes:swagger:docs
$ PATHS_FILE="swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:docs    # pathsファイルを指定してドキュメント生成

$ # SwaggerEditorでドキュメント編集
$ bundle exec rake routes:swagger:editor
$ PATHS_FILE="swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:editor  # pathsファイルを指定してドキュメント編集
$ # SwaggerUIでドキュメント閲覧
$ bundle exec rake routes:swagger:ui
$ PATHS_FILE="swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:ui      # pathsファイルを指定してドキュメント閲覧
$ # テキストエディタでドキュメント編集(初期設定時、git管理しないswagger_docs/swagger_doc.ymlを監視)
$ bundle exec rake routes:swagger:monitor
$ PATHS_FILE="swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:monitor # pathsファイルを指定してドキュメント監視

$ # ドキュメントを分解・分析
$ SWAGGER_FILE="~/Desktop/swagger.yml" bundle exec rake routes:swagger:analyze
$ # どこからも参照されてないcomponents/schemas(requestBodies, ...)を削除
$ bundle exec rake routes:swagger:clean
$ # githubにホスティング
$ bundle exec rake routes:swagger:deploy
$ # ドキュメントを配布(初期設定時、配布ファイルは、swagger_docs/swagger_doc.yml)
$ bundle exec rake routes:swagger:dist
$ PATHS_FILE="swagger_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:swagger:dist    # pathsファイルを指定してドキュメント配布
 
# pathsファイルのリスト取得
$ bundle exec rake routes:swagger:paths_ls
# pathsファイルの編集履歴表示
$ bundle exec rake routes:swagger:paths_stats
```

## 📚 More Usage

- [How to generate docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_GENERATE_DOCS.md)
- [How to start swagger editor](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_EDITOR.md)
- [How to start swagger ui](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_START_SWAGGER_UI.md)
- [How to monitor swagger document](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_MONITOR_SWAGGER_DOC.md)
- [How to analyze docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_ANALYZE_DOCS.md)
- [How to clean docs](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_CLEAN_DOCS.md)
- [How to deploy swagger doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DEPLOY_SWAGGER_DOC.md)
- [How to use tag namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_TAG_NAMESPACE.md)
- [How to use schema namespace](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_SCHEMA_NAMESPACE.md)
- [How to use hook when generate doc](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_USE_HOOK_WHEN_GENERATE_DOC.md)
- [How to display paths list](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DISPLAY_PATHS_LIST.md)
- [How to display paths stats](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/HOW_TO_DISPLAY_PATHS_STATS.md)


## ⚾️ sample

実際の使用例を見るにはこちらのリポジトリを参考にしてください。

- [yukihirop/rtsd-k8s-example](https://github.com/yukihirop/rtsd-k8s-example)
- [yukihirop/rtsd-moneyforward-example](https://github.com/yukihirop/rtsd-moneyforward-example)
- [yukihirop/rtsd-leaddesk-example](https://github.com/yukihirop/rtsd-leaddesk-example)
- [yukihirop/rtsd-advanced-example](https://github.com/yukihirop/rtsd-advanced-example)

## ❤️ Support Rails Version

- Rails (>= 4.2.5.1)

## ❤️ Support Ruby Version

- Ruby (>= 2.3.3p222 (2016-11-21 revision 56859) [x86_64-darwin18])

## ❤️ Support Rouging

- Rails Engine Routing
- Rails Normal Routing

## ❤️ Support OpenAPI Schema

|version|document|
|-------|--------|
|v3|[versions/v3.md](https://github.com/yukihirop/routes_to_swagger_docs/blob/master/docs/versions/v3.md)|

## ❗️ Convention over Configuration (CoC)

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

設定可能な設定に関して説明します。

#### basic

|option|description|default|
|------|-----------|---|
|version|OpenAPIのバージョン| `:v3` |
|root_dir_path|ドキュメントの保存パス| `"./swagger_docs"` |
|schema_save_dir_name|分解したスキーマの保存ディレクトリ名|`"src"`|
|doc_save_file_name|生成したドキュメントのファイル名|`"swagger_doc.yml"`|
|force_update_schema|既生のドキュメントをルーティング情報から生成されたデータで更新するか否か|`false`|
|use_tag_namespace|タグ名にネームスペースを使うか否か|`true`|
|use_schema_namespace|components/{schemas,requestBodies}名に擬似ネームスペースを利用するか否か|`true`|
|interval_to_save_edited_tmp_schema|SwaggerEditor上で編集されたドキュメントをメモリに保存する間隔(sec)|`15`|
|http_statuses_when_http_method|HTTPメソッド毎にどのHTTPステータスのレスポンスを用意するかを決める設定|omission...|
|http_methods_when_generate_request_body|リクエストボディーを生成する時のHTTPメソッド|`[post put patch]`|
|namespace_type|components/{schemas,requestBodies,...}名で使用する擬似ネームスペースの種類(:dot or :underbar)| `:underbar` |

#### server

|option|children option|description|default|
|------|---------------|-----------|-------|
|server|data|サーバー情報(url, description) |[{ url: `http://localhost:3000`, description: `localhost` }] |

#### swagger

|option|children option|grandchild option|description|default|
|------|---------------|-----------------|-----------|-------|
|swagger|ui|image|SwaggerUIのDockerイメージ|`"swaggerapi/swagger-ui"`|
|swagger|ui|port|SwaggerUIのポート|`"8080"`|
|swagger|ui|exposed_port|SwaggerUIの公開ポート|`"8080/tcp"`|
|swagger|ui|volume|SwaggerUIのVolume|`"/app/swagger.json"`|
|swagger|editor|image|SwaggerEditorのDockerイメージ|`"swaggerapi/swagger-editor"`|
|swagger|editor|port|SwaggerEditorのポート|`"8080"`|
|swagger|editor|exposed_port|SwaggerEditorの公開ポート|`"8080/tcp"`|

#### hook

|option|description|default|
|------|-----------|-------|
|use_object_classes|ドキュメント生成時に使用するオブジェクトクラスの設定|{ info_object: `RoutesToSwaggerDocs::Schema::V3::InfoObject`,<br>paths_object: `RoutesToSwaggerDocs::Schema::V3::PathsObject`,<br>path_item_object: `RoutesToSwaggerDocs::Schema::V3::PathItemObject`, external_document_object: `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`,<br> components_object: `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`,<br> components_schema_object: `RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject`, <br> components_request_body_object:`RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject` }|

#### tool

|option|children option|grandchild option|description|default|
|------|---------------|-----------------|-----------|-------|
|tool|paths_stats|month_to_turn_to_warning_color|警告色を表示するまでの期間(ヶ月)|`3`|
|tool|paths_stats|warning_color|警告色|`:red`|
|tool|paths_stats|table_title_color|テーブルのタイトルの色|`:yellow`|
|tool|paths_stats|heading_color|ヘッダーの色|`:yellow`|
|tool|paths_stats|highlight_color|強調色|`:magenta`|

Please refer to [here](https://github.com/janlelis/paint) for the color.

## Environment variables

環境変数は以下を用意しております。

|variable|description|default|
|--------|-----------|-------|
|PATHS_FILE|pathsファイルのパス|`""`|
|SWAGGER_FILE|analyzeするドキュメントへのパス|`""`|


## .paths

`.paths` ファイルを書くことで必要な分だけドキュメントを閲覧・編集・配布する事が可能になります。

`#` から始まる行はコメントとして扱われ無視されます。重複も無視されます。

`paths` ディレクトリ以下のパスを書きます。

`swagger_docs/.paths`
```
#account_user_role.yml    # ignore
account.yml
account.yml               # ignore
account.yml               # ignore
```

## 💊 Life Cycle Methods (Hook Metohds)

ドキュメント生成時に、フックを可能にするメソッドを用意しております。

- `before_create`
- `after_create`

フック可能なオブジェクトは以下の通りです。

- `RoutesToSwaggerDocs::Schema::V3::InfoObject`
- `RoutesToSwaggerDocs::Schema::V3::PathsObject`
- `RoutesToSwaggerDocs::Schema::V3::PathItemObject`
- `RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject`
- `RoutesToSwaggerDocs::Schema::V3::ComponentsObject`
- `RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject`
- `RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject`

これらのクラスを継承して、フックの設定を書きます。以下に例を用意しました。

#### case: InfoObject

```ruby
class CustomInfoObject < RoutesToSwaggerDocs::Schema::V3::InfoObject
  before_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, path|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathsObject

```ruby
class CustomPathsObject < RoutesToSwaggerDocs::Schema::V3::PathsObject
  before_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: PathItemObject

```ruby
class CustomPathItemObject < RoutesToSwaggerDocs::Schema::V3::PathItemObject
  before_create do |doc, path|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: ExternalDocumentObject

```ruby
class CustomExternalDocumentObject < RoutesToSwaggerDocs::Schema::V3::ExternalDocumentObject
  before_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: ComponentsObject

```ruby
class CustomComponentsObject < RoutesToSwaggerDocs::Schema::V3::ComponentsObject
  before_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

#### case: Components::SchemaObject

```ruby
class CustomComponentsSchemaObject < RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject
  before_create do |doc, schema_name|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

ドキュメント生成時にcomponents/schemas名を上書きしたい場合は以下の様にします。

```ruby
class CustomComponentsSchemaObject < RoutesToSwaggerDocs::Schema::V3::Components::SchemaObject
  def components_schema_name(doc, path_component, tag_name, verb, http_status, schema_name)
    # [重要] 返値は文字列であるべきです。
    # 初期値はschema_name
    schema_name
  end
end
```

`path_component` は `RoutesToSwaggerDocs::Routing::PathComponent` のインスタンスです。

```ruby
module RoutesToSwaggerDocs
  module Routing
    class PathComponent < BaseComponent
      def initialize(path)
      def to_s
      def symbol_to_brace
      def path_parameters_data
      def path_excluded_path_parameters
      def exist_path_parameters?
      def path_parameters
      private
      def without_format
```

#### case: Components::RequestBodyObject

```ruby
class CustomComponentsRequestBodyObject < RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  before_create do |doc, schema_name|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something .... 
    })
  end

  after_create do |doc, schema_name|
    # [重要] docへの破壊的な変更をしてください。
    # [重要] railsが提供するメソッドを使用する事ができます。
    doc.merge!({
      # Something ....
    })
  end
end
```

ドキュメント生成時にcomponents/requestBodies名を上書きしたい場合は以下の様にします。

```ruby
class CustomComponentsRequestBodyObject < RoutesToSwaggerDocs::Schema::V3::Components::RequestBodyObject
  def components_request_body_name(doc, path_component, tag_name, verb, schema_name)
    # [重要] 返値は文字列であるべきです。
    # 初期値はschema_name
    schema_name
  end

  def components_schema_name(doc, path_component, tag_name, verb, schema_name)
    # [重要] 返値は文字列であるべきです。
    # 初期値はschema_name
    schema_name
  end
end
```

そして最後に設定を書きます。

```ruby
# もし、InfoObjectとPathItemObjectをカスタムのものにしたい場合は以下の様にします。
RoutesToSwaggerDocs.configure do |config|
  # 
  # omission ...
  # 
  config.use_object_classes.merge!({
    info_object:      CustomInfoObject,
    path_item_object: CustomPathItemObject
  })
end
```

これだけです。

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

1. Fork it ( http://github.com/yukihirop/routes_to_swagger_docs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
