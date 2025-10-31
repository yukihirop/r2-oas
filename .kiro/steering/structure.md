# R2-OAS プロジェクト構造

## ルートディレクトリ構成

```
r2-oas/
├── lib/                      # メインコード
│   ├── r2-oas.rb            # エントリーポイント
│   └── r2-oas/              # gem本体
├── spec/                     # RSpecテスト
├── sig/                      # RBS型定義
├── docs/                     # ドキュメント (GitHub Pages)
├── devscript/               # 開発用スクリプト
├── gemfiles/                # Appraisal用Gemfile
├── bin/                      # 実行ファイル (console, setup)
├── coverage/                # カバレッジレポート
├── .github/                 # GitHub Actions, Issue/PR テンプレート
├── .claude/                 # Claude Code設定
├── .kiro/                   # Kiro仕様管理
│   ├── steering/            # ステアリングドキュメント
│   └── specs/               # 仕様ドキュメント
├── Gemfile                  # 依存関係定義
├── r2-oas.gemspec           # Gem仕様
├── Rakefile                 # タスク定義
├── Steepfile                # Steep型チェック設定
├── steep_expectations.yml   # Steep期待値設定
└── README.md                # プロジェクト概要
```

## lib/ ディレクトリ構造

### トップレベル構造

```
lib/
├── r2-oas.rb                         # gem エントリーポイント、モジュール定義
└── r2-oas/
    ├── version.rb                    # バージョン定義
    ├── public.rb                     # 公開API定義
    ├── base.rb                       # 基底クラス
    ├── errors.rb                     # カスタム例外
    ├── configuration.rb              # 設定システム
    ├── app_configuration.rb          # アプリケーション設定
    ├── task.rb                       # Rakeタスクロード
    │
    ├── schema/                       # スキーマ処理 (メイン機能)
    ├── routing/                      # Rails ルーティング解析
    ├── plugin/                       # プラグインシステム
    ├── hooks/                        # フックシステム
    ├── configuration/                # 設定関連
    ├── deploy/                       # デプロイ機能
    ├── tasks/                        # Rakeタスク
    ├── helpers/                      # ヘルパーモジュール
    ├── logger/                       # ログ出力
    ├── support/                      # サポート機能
    ├── shared/                       # 共有モジュール
    └── lib/                          # 内部ライブラリ
```

### schema/ ディレクトリ (コア機能)

```
schema/
├── base.rb                   # Schema基底クラス
├── generator.rb              # Routes → OpenAPI 生成
├── analyzer.rb               # OpenAPI → ソースファイル解析
├── builder.rb                # ソースファイル → OpenAPI 構築
├── squeezer.rb               # 複数ファイル結合
├── cleaner.rb                # 未使用コンポーネント削除
├── editor.rb                 # Swagger Editor統合
├── ui.rb                     # Swagger UI統合
├── monitor.rb                # リアルタイム監視
├── manager/                  # ファイル管理
│   ├── file_manager.rb
│   └── file/
│       └── path_item_file_manager.rb
└── v3/                       # OpenAPI 3.0専用実装
    ├── base.rb
    ├── generator.rb
    ├── analyzer.rb
    ├── builder.rb
    ├── squeezer.rb
    ├── cleaner.rb
    ├── generator/            # 生成処理詳細
    │   ├── base_generator.rb
    │   ├── doc_generator.rb
    │   ├── path_generator.rb
    │   ├── schema_generator.rb
    │   ├── components_generator.rb
    │   └── components/
    │       ├── object_generator.rb
    │       └── request_body_generator.rb
    ├── analyzer/             # 解析処理詳細
    │   ├── base_analyzer.rb
    │   ├── path_analyzer.rb
    │   ├── tag_analyzer.rb
    │   ├── components_analyzer.rb
    │   └── components/
    │       └── object_analyzer.rb
    ├── builder/              # 構築処理詳細
    │   ├── base_builder.rb
    │   └── doc_builder.rb
    ├── cleaner/              # クリーン処理詳細
    │   ├── base_cleaner.rb
    │   └── components_cleaner.rb
    ├── manager/              # ファイル・差分管理
    │   ├── file_manager.rb
    │   ├── pathname_manager.rb
    │   ├── file/
    │   │   ├── base_file_manager.rb
    │   │   ├── components_file_manager.rb
    │   │   ├── path_item_file_manager.rb
    │   │   └── include_ref_base_file_manager.rb
    │   └── diff/
    │       ├── base_diff_manager.rb
    │       ├── base_hash_diff_manager.rb
    │       ├── base_array_diff_manager.rb
    │       ├── components_diff_manager.rb
    │       └── tag_diff_manager.rb
    └── object/               # OpenAPIオブジェクト表現
        ├── from_routes/      # ルーティングから生成
        │   ├── base_object.rb
        │   ├── openapi_object.rb
        │   ├── info_object.rb
        │   ├── external_document_object.rb
        │   └── components/
        │       └── schema_object.rb
        └── from_files/       # ファイルから読み込み
            ├── base_object.rb
            ├── paths_object.rb
            ├── components_object.rb
            ├── components/
            │   ├── schema_object.rb
            │   └── request_body_object.rb
            └── utils/
                ├── all.rb
                └── deep_methods.rb
```

### routing/ ディレクトリ (Railsルーティング解析)

```
routing/
├── base.rb                   # ルーティング基底クラス
├── parser.rb                 # ルーティング解析
├── adjustor.rb               # ルート調整
└── components/               # ルーティングコンポーネント
    ├── all.rb
    ├── base_component.rb
    ├── verb_component.rb     # HTTPメソッド処理
    ├── path_component.rb     # パス処理
    └── request_component.rb  # リクエスト処理
```

### plugin/ ディレクトリ (プラグインシステム)

```
plugin/
├── public.rb                 # プラグイン公開API
├── base.rb                   # プラグイン基底クラス
├── executor.rb               # プラグイン実行
├── hookable.rb               # フック機能
└── transform/                # トランスフォーム
    ├── transform.rb
    └── v3/
        ├── transform.rb
        └── visitable.rb      # Visitorパターン
```

### hooks/ ディレクトリ (フックシステム)

```
hooks/
├── hook.rb                   # フック基底
├── global_hook.rb            # グローバルフック
└── repository.rb             # フックリポジトリ
```

### その他の主要ディレクトリ

```
configuration/
├── paths_config.rb           # パス設定

app_configuration/
├── deprecation.rb            # 非推奨機能管理
├── server.rb                 # サーバー設定
└── swagger/
    ├── editor.rb             # Swagger Editor設定
    └── ui.rb                 # Swagger UI設定

deploy/
├── client.rb                 # デプロイクライアント
└── swagger-ui/               # Swagger UI静的ファイル
    └── dist/

tasks/
└── *.rake                    # Rakeタスク定義

helpers/
└── file_helper.rb            # ファイル操作ヘルパー

logger/
└── stdout_logger.rb          # 標準出力ロガー

support/
└── deprecation/              # 非推奨警告
    └── behavior.rb

shared/
├── all.rb
└── callable.rb               # 共通モジュール

lib/
├── core_ext/                 # Rubyコア拡張
│   ├── all.rb
│   ├── hash/
│   │   └── deep_merge.rb
│   ├── object/
│   │   └── blank.rb
│   └── string/
│       └── filters.rb
└── three-way-merge/
    └── twm.rb                # 3-wayマージ
```

## spec/ テストディレクトリ構造

```
spec/
├── spec_helper.rb            # RSpec設定
├── rails_helper.rb           # Rails統合設定
├── support/                  # テストサポート
├── fixtures/                 # テストフィクスチャ
└── r2-oas/                   # lib/r2-oas に対応
    ├── schema/
    ├── routing/
    ├── plugin/
    └── ...
```

## 生成されるoas_docs/ ディレクトリ構造 (Railsプロジェクト側)

```
oas_docs/                     # R2OAS作業ディレクトリ
├── .paths                    # パス管理
├── schema/                   # 生成されたスキーマ
│   ├── openapi.yml          # トップレベル
│   ├── info.yml
│   ├── servers.yml
│   ├── tags/                # タグ定義
│   ├── paths/               # パス定義 (コントローラーごと)
│   │   └── api/
│   │       └── v1/
│   │           ├── user.yml
│   │           └── task.yml
│   └── components/          # 再利用可能コンポーネント
│       ├── schemas/
│       │   └── api/
│       │       └── v1/
│       │           ├── user.yml
│       │           └── task.yml
│       ├── requestBodies/
│       ├── responses/
│       ├── parameters/
│       └── examples/
├── plugins/                  # ローカルプラグイン
│   └── helpers/
└── tasks/                    # ローカルRakeタスク
    └── helpers/
```

## ファイル命名規則

### Rubyファイル
- **snake_case**: 全てのRubyファイルは `snake_case` で命名
- **クラス名対応**: ファイル名はクラス名に対応
  - 例: `BaseGenerator` → `base_generator.rb`
  - 例: `PathItemFileManager` → `path_item_file_manager.rb`

### OpenAPIスキーマファイル (YAML)
- **Convention over Configuration** 適用

#### パスファイル (`paths/`)
- **ルール**: タグ名 = コントローラー名 → ファイル名
- 例:
  - コントローラー: `Api::V1::UsersController`
  - タグ名: `api/v1/user`
  - ファイル: `paths/api/v1/user.yml`

#### コンポーネントファイル (`components/`)
- **ルール1**: アンダースコア `_` → スラッシュ `/`
  - コンポーネント名: `Api_V1_User`
  - ファイル: `components/schemas/api/v1/user.yml`

- **ルール2**: ドット `.` → スラッシュ `/`
  - コンポーネント名: `api.v1.User`
  - ファイル: `components/schemas/api/v1/user.yml`

- **意味**: `_` や `.` は名前空間の区切りを表現
- **フォーマット**: `Namespace1_Namespace2_Model` または `namespace1.namespace2.Model`

## コード構成パターン

### モジュール構造
```ruby
module R2OAS
  module Schema
    module V3
      class Generator
        module Components
          class ObjectGenerator
          end
        end
      end
    end
  end
end
```

- トップレベル: `R2OAS` モジュール
- 機能別: `Schema`, `Routing`, `Plugin` など
- バージョン: `V3` (OpenAPI 3.0)
- 詳細実装: ネストしたクラス/モジュール

### autoload パターン
```ruby
module R2OAS
  autoload :Base, 'r2-oas/base'
  autoload :NoImplementError, 'r2-oas/errors'

  module Schema
    autoload :Generator, 'r2-oas/schema/generator'
  end
end
```

遅延ロードにより起動時間を短縮。

### mixin パターン
```ruby
module R2OAS
  module Helpers
    module FileHelper
      def mkdir_p_dir_or_skip(path)
        # ...
      end
    end
  end
end

class SomeClass
  include R2OAS::Helpers::FileHelper
end
```

共通機能をモジュールとして切り出し。

## import/require 構成

### require パターン
```ruby
# 絶対パス
require 'r2-oas/version'
require 'r2-oas/configuration'

# 相対パス (同一ディレクトリ内)
require_relative 'app_configuration'
require_relative 'support/deprecation'
```

### autoload パターン
```ruby
# 遅延ロード
autoload :Generator, 'r2-oas/schema/generator'
```

### ファイル読み込み順序
1. `lib/r2-oas.rb` - エントリーポイント
2. `version.rb`, `public.rb` - バージョンと公開API
3. `configuration.rb` - 設定システム
4. `task.rb` - Rakeタスク
5. autoload により必要に応じて個別モジュールをロード

## 主要なアーキテクチャ原則

### 1. Railsプラグイン統合
- Railtie を利用した Rails統合
- Rakeタスクによる統一インターフェース
- `R2OAS.configure` ブロックでの設定

### 2. OpenAPI v3 準拠
- `schema/v3/` に OpenAPI 3.0専用実装
- 将来的な複数バージョン対応を想定

### 3. 関心の分離
- **Generator**: ルーティング → OpenAPI
- **Analyzer**: OpenAPI → ソースファイル
- **Builder**: ソースファイル → OpenAPI (プラグイン適用)
- **Cleaner**: 未使用コンポーネント削除
- **Squeezer**: ファイル結合

### 4. 拡張性
- **プラグインシステム**: カスタム変換処理
- **フックシステム**: 各処理段階への介入
- **ローカルタスク**: 独自Rakeタスク追加

### 5. ファイルベース管理
- YAML分割による管理性向上
- Git friendlyな構造
- 差分管理の容易さ

### 6. 型安全性
- RBS型定義 (`sig/`)
- Steepによる型チェック
- 開発時の安全性確保

## ディレクトリ作成ルール

### 自動生成ディレクトリ
```bash
# rake routes:oas:init で生成
oas_docs/
├── .paths
├── schema/
├── plugins/
│   └── helpers/
└── tasks/
    └── helpers/
```

### 動的生成ディレクトリ
```bash
# rake routes:oas:docs で必要に応じて生成
oas_docs/schema/
├── paths/api/v1/         # 名前空間に応じて
├── components/schemas/api/v1/
├── components/requestBodies/
└── ...
```

## 重要なファイル

### 設定ファイル
- `Gemfile`: 依存関係
- `r2-oas.gemspec`: Gem仕様
- `Rakefile`: タスク定義
- `Steepfile`: 型チェック設定
- `.ruby-version`: Rubyバージョン指定

### ドキュメント
- `README.md`: プロジェクト概要 (英語)
- `README.ja.md`: プロジェクト概要 (日本語)
- `CHANGELOG.md`: 変更履歴
- `GEMSPEC.md`: Gem説明詳細
- `LICENSE.txt`: MIT License

### メタファイル
- `.gitignore`: Git除外設定
- `.rspec`: RSpec設定
- `.rubocop.yml`: Rubocop設定
- `mise.toml`: mise (バージョン管理ツール) 設定
