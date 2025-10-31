# R2-OAS 技術スタック

## アーキテクチャ

### システム設計
R2-OASは、Railsアプリケーションに統合されるRuby gemとして設計されています。

```
Rails Application
    ↓
R2OAS Gem (Rake Tasks)
    ↓
┌──────────────┬──────────────┬──────────────┐
│ Generator    │ Analyzer     │ Builder      │
│ (ルーティング→  │ (OAS→ソース) │ (ソース→OAS)  │
│  OpenAPI)    │              │              │
└──────────────┴──────────────┴──────────────┘
    ↓
OpenAPI Document (YAML)
    ↓
┌──────────────┬──────────────┐
│ Swagger UI   │ Swagger Editor│
│ (Docker)     │ (Docker)      │
└──────────────┴──────────────┘
```

### コアコンポーネント

#### 1. Schema System (OpenAPI v3)
- **Generator**: Railsルーティングを解析してOpenAPIスキーマを生成
- **Analyzer**: OpenAPIドキュメントを読み込んでソースファイルに分解
- **Builder**: ソースファイルからOpenAPIドキュメントを構築
- **Squeezer**: 複数のスキーマファイルを結合
- **Cleaner**: 未使用のコンポーネントを削除

#### 2. Plugin System
- カスタムトランスフォームを適用可能
- Visitorパターンによる柔軟な処理
- ローカルプラグインのサポート (`oas_docs/plugins/`)

#### 3. Hook System
- グローバルフックとリポジトリフック
- ドキュメント生成の各ステージで処理を挿入

#### 4. Configuration System
- YAMLベースの設定
- パス、出力形式、動作オプションをカスタマイズ可能

## バックエンド技術

### 言語・フレームワーク
- **Ruby**: >= 3.2.0 (3.2.6, 3.3.6, 3.4.x をサポート)
- **Rails**: >= 7.2.0 (7.2.2.2, 8.x をサポート)
- **Gem形式**: 標準的なRubyGemとして配布

### 主要な依存関係

#### 実行時依存 (Runtime Dependencies)
```ruby
# Docker操作
docker-api >= 1.34.2          # Docker コンテナ管理

# データ処理
easy_diff >= 1.0.0            # スキーマの差分検出
key_flatten >= 1.0.0          # ハッシュのフラット化

# 非同期処理
eventmachine >= 1.2.0         # ファイル監視 (monitor機能)

# ブラウザ自動化
watir >= 6.16.5               # Swagger UI/Editor の自動起動

# Rails統合
railties >= 7.2.0             # Rakeタスク統合
```

#### 開発時依存 (Development Dependencies)
```ruby
# テスト
rspec ~> 3.0                  # テストフレームワーク
activerecord >= 7.2.0         # テスト用DB
sqlite3 ~> 2.0                # テスト用DB

# 品質管理
rubocop                       # コード静的解析
coveralls                     # カバレッジ計測

# 型チェック
steep                         # RBS型チェッカー

# 多バージョンテスト
appraisal                     # 複数のRails/Rubyバージョンでテスト

# その他
bundler >= 2.0                # 依存関係管理
rake ~> 13.0                  # タスクランナー
pry                           # デバッガ
```

## 開発環境

### 必須ツール

#### 1. Docker環境
```bash
# Swagger UI/Editor のDockerイメージ
docker pull swaggerapi/swagger-editor:latest
docker pull swaggerapi/swagger-ui:latest
```

#### 2. Chromedriver
```bash
# macOS
brew install chromedriver

# Linux
# 公式サイトからダウンロード
```

#### 3. Ruby環境管理
- mise/asdf/rbenvなどのバージョン管理ツール推奨
- `.ruby-version` ファイルで指定 (現在: 3.4.x)

### セットアップ手順

```bash
# 1. リポジトリのクローン
git clone https://github.com/yukihirop/r2-oas.git
cd r2-oas

# 2. 依存関係のインストール
bundle install

# 3. テストの実行
bundle exec rspec

# 4. 型チェック
bundle exec steep check

# 5. コード品質チェック
bundle exec rubocop
```

## 共通コマンド

### 開発コマンド

#### テスト実行
```bash
# 全テスト実行
bundle exec rspec

# 特定のテストファイル実行
bundle exec rspec spec/path/to/spec_file.rb

# 複数のRubyバージョンでテスト
/bin/bash devscript/all_support_ruby.sh rspec

# 特定のRubyバージョンでテスト
/bin/bash devscript/all_support_ruby.sh rspec 3.2.6 3.3.6
```

#### 型チェック (RBS/Steep)
```bash
# 型エラーの統計表示
bundle exec steep stats

# 詳細な型エラーチェック
bundle exec steep check

# steep ignore コメント生成補助
bundle exec rake steep:ignore:preview   # プレビュー
bundle exec rake steep:ignore:auto      # 自動適用
bundle exec rake steep:ignore:dig       # エラー種類別リスト
bundle exec rake steep:ignore:file      # ファイル別リスト
```

#### コード品質
```bash
# Rubocop実行
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

#### 複数バージョン対応
```bash
# 全サポートRubyバージョンでbundle install
/bin/bash devscript/all_support_ruby.sh bundle

# 特定バージョンのみ
/bin/bash devscript/all_support_ruby.sh bundle 3.2.6 3.3.6
```

### Railsプロジェクトでの利用コマンド

#### 初期化・生成
```bash
# 初期化
bundle exec rake routes:oas:init

# ドキュメント生成
bundle exec rake routes:oas:docs

# 特定パスのみ生成
PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:docs
```

#### 閲覧・編集
```bash
# Swagger Editorで編集
bundle exec rake routes:oas:editor

# Swagger UIで閲覧
bundle exec rake routes:oas:ui

# 特定パスのみ
PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml" bundle exec rake routes:oas:editor
```

#### ビルド・デプロイ
```bash
# ビルド (プラグイン適用)
bundle exec rake routes:oas:build

# クリーン (未使用コンポーネント削除)
bundle exec rake routes:oas:clean

# デプロイ
bundle exec rake routes:oas:deploy
```

#### モニタリング・解析
```bash
# リアルタイム監視
bundle exec rake routes:oas:monitor

# 既存OpenAPIドキュメントの解析
OAS_FILE="~/Desktop/swagger.yml" bundle exec rake routes:oas:analyze
```

## 環境変数

### 動作制御
```bash
# 特定のパスファイルのみ処理
PATHS_FILE="oas_docs/schema/paths/api/v1/task.yml"

# 外部OpenAPIファイル指定 (analyze時)
OAS_FILE="~/Desktop/swagger.yml"

# ログ出力制御 (設定ファイルでも可)
# R2OAS.configure で silent_mode を設定
```

### Docker関連
```bash
# Dockerホスト (デフォルト: unix:///var/run/docker.sock)
DOCKER_HOST="tcp://localhost:2375"
```

## ポート設定

### Swagger UI/Editor
- **Swagger Editor**: デフォルトポート 8080 (設定可能)
- **Swagger UI**: デフォルトポート 8081 (設定可能)

設定例:
```ruby
# config/initializers/r2-oas.rb
R2OAS.configure do |config|
  config.swagger_editor_port = 8080
  config.swagger_ui_port = 8081
end
```

## 型システム (RBS/Steep)

### RBS署名ファイル
- 場所: `sig/` ディレクトリ
- 用途: Ruby型情報の定義
- チェッカー: Steep

### Steep設定
- 設定ファイル: `Steepfile`
- 期待値設定: `steep_expectations.yml`
- 型エラーの抑制: `# steep:ignore <ErrorType>` コメント

### 型チェックワークフロー
1. `bundle exec steep stats` で概要確認
2. `bundle exec steep check` で詳細確認
3. `bundle exec rake steep:ignore:preview` で抑制候補確認
4. `bundle exec rake steep:ignore:auto` で自動抑制適用

## アーキテクチャ上の重要な決定

### 1. Convention over Configuration (CoC)
- タグ名 = コントローラー名 → パスファイル名
- コンポーネント名の `_` または `.` → ディレクトリ区切り `/`

### 2. ファイル分割戦略
- paths: コントローラーごとにファイル分割
- components: 名前空間ごとにファイル分割
- schemas/requestBodies/responses: 個別ファイル化

### 3. プラグイン/フック機構
- ローカルプラグイン: `oas_docs/plugins/`
- ローカルタスク: `oas_docs/tasks/`
- 自動ロード機構でカスタマイズ容易化

### 4. 双方向変換
- Generator: Routes → OpenAPI
- Analyzer: OpenAPI → Source Files
- Builder: Source Files → OpenAPI (with plugins)

## CORS設定

Swagger UI/Editorからのアクセスを許可するため、CORS設定が必要:

```ruby
# rack-cors使用
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end

# または手動設定
before do
  header['Access-Control-Allow-Origin'] = '*'
  header['Access-Control-Request-Method'] = '*'
end
```
