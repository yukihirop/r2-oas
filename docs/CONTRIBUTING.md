# R2-OAS ドキュメント貢献ガイド

R2-OASドキュメントへの貢献に興味を持っていただきありがとうございます！このガイドでは、ドキュメントの追加・編集方法を説明します。

## 📁 ディレクトリ構造

```
docs/
├── _config.yml              # Jekyll設定ファイル
├── _layouts/                # カスタムレイアウト（必要に応じて）
├── _includes/               # 再利用可能なコンポーネント
├── _sass/                   # カスタムスタイル（必要に応じて）
├── assets/                  # 静的アセット（画像、CSS、JSなど）
│   ├── css/
│   ├── images/
│   └── js/
├── index.md                 # トップページ
├── usage/                   # 使い方ガイド
│   ├── index.md            # セクションインデックス
│   ├── use-plugins.md
│   ├── define-tasks.md
│   └── ...
├── configuration/           # 設定ガイド
│   ├── index.md
│   ├── COC.md
│   ├── configure.md
│   └── CORS.md
├── schema/                  # スキーマリファレンス
│   ├── index.md
│   └── 3.0.0.md
├── guides/                  # ガイド・注意事項
│   ├── index.md
│   └── if-clash.md
├── troubleshooting/         # トラブルシューティング
│   ├── index.md
│   └── runtime-error.md
├── CONTRIBUTING.md          # このファイル
├── TEST_CHECKLIST.md        # テストチェックリスト
└── DEPLOYMENT_CHECKLIST.md # デプロイチェックリスト
```

### ディレクトリの役割

| ディレクトリ | 用途 | 例 |
|------------|------|-----|
| `usage/` | R2-OASの使い方 | プラグイン、タスク定義、初期化など |
| `configuration/` | 設定方法 | COC、Configure、CORSなど |
| `schema/` | OpenAPIスキーマ仕様 | バージョン別スキーマ定義 |
| `guides/` | ガイドと注意事項 | ベストプラクティス、注意点 |
| `troubleshooting/` | トラブルシューティング | エラー対処法、FAQ |

## 📝 Front Matterテンプレート

すべてのMarkdownファイルの先頭には、Front Matterを記載する必要があります。

### 基本テンプレート

```yaml
---
layout: default
title: "ページタイトル"
permalink: "/section/page-name/"
parent: "親セクション名"
nav_order: 1
---

# ページタイトル

ここにコンテンツを記載します。
```

### Front Matterフィールド説明

| フィールド | 必須 | 説明 | 例 |
|-----------|------|------|-----|
| `layout` | ✅ | 使用するレイアウト | `default`, `home`, `page` |
| `title` | ✅ | ページタイトル | `"Use Plugins"` |
| `permalink` | 推奨 | カスタムURL（SEOフレンドリー） | `"/usage/use-plugins/"` |
| `parent` | オプション | 親ページ（階層構造用） | `"Usage"` |
| `nav_order` | オプション | ナビゲーション順序 | `1`, `2`, `3` |
| `has_children` | オプション | 子ページの有無 | `true`, `false` |
| `grand_parent` | オプション | 祖父母ページ（3階層用） | `"Documentation"` |
| `description` | オプション | SEO用説明文 | `"How to use plugins"` |
| `last_modified_at` | オプション | 最終更新日（手動設定） | `2025-10-30` |

### セクションインデックスページ

各セクションの `index.md` には `has_children: true` を設定します。

```yaml
---
layout: default
title: "Usage"
permalink: "/usage/"
nav_order: 2
has_children: true
---

# Usage

R2-OASの使い方を説明します。
```

### 子ページ

親セクションに属するページには `parent` を設定します。

```yaml
---
layout: default
title: "Use Plugins"
permalink: "/usage/use-plugins/"
parent: "Usage"
nav_order: 1
---

# Use Plugins

プラグインの使い方を説明します。
```

### 最終更新日の設定

#### 方法1: 手動設定（推奨）

Front Matterに `last_modified_at` フィールドを追加します。

```yaml
---
layout: default
title: "Use Plugins"
permalink: "/usage/use-plugins/"
parent: "Usage"
last_modified_at: 2025-10-30
---
```

#### 方法2: Git履歴から取得

コマンドラインでファイルの最終更新日を確認：

```bash
# 特定ファイルの最終更新日を取得
git log -1 --format="%ai" -- docs/usage/use-plugins.md

# 出力例: 2025-10-30 12:34:56 +0900
```

このコマンドで取得した日付を `last_modified_at` に設定します。

**注意**: GitHub Pagesでは `jekyll-last-modified-at` プラグインがサポートされていないため、自動更新はできません。ページを更新する際は、手動で `last_modified_at` を更新してください。

## 🎨 Markdown記法

### 見出し

```markdown
# H1 - ページタイトル
## H2 - セクション
### H3 - サブセクション
```

### コードブロック

````markdown
```ruby
class SampleTransform < R2OAS::Plugin::Transform
  self.plugin_name = 'r2oas-plugin-transform-sample'
end
```

```bash
$ bundle exec rake routes:oas:docs
```
````

### Calloutボックス（情報・警告）

#### 情報ボックス (Note)

```markdown
{: .note }
> Starting from `v0.4.0`, you can use plugins.
```

#### 警告ボックス (Warning)

```markdown
{: .warning }
> Be sure to write the plugin so that it is idempotent.
```

#### その他のスタイル

Just-the-Docsテーマは以下のスタイルもサポートしています：

```markdown
{: .important }
> This is important information.

{: .new }
> This is a new feature.

{: .highlight }
> This is highlighted content.
```

### リンク

#### 内部リンク

```markdown
[Use Plugins]({{ site.baseurl }}/usage/use-plugins/)
```

#### 外部リンク

```markdown
[GitHub Repository](https://github.com/yukihirop/r2-oas)
```

### テーブル

```markdown
| 項目 | 説明 |
|-----|------|
| Type | Transform |
| Version | v0.4.0+ |
```

### リスト

```markdown
- 項目1
- 項目2
  - サブ項目2-1
  - サブ項目2-2

1. 順序付き項目1
2. 順序付き項目2
```

## 🛠️ ローカル開発環境のセットアップ

### 前提条件

- Ruby 2.7以上
- Bundler

### セットアップ手順

1. **リポジトリをクローン**

```bash
git clone https://github.com/yukihirop/r2-oas.git
cd r2-oas/docs
```

2. **依存関係をインストール**

```bash
bundle install
```

3. **ローカルサーバーを起動**

```bash
bundle exec jekyll serve
```

または、ライブリロード機能付きで起動：

```bash
bundle exec jekyll serve --livereload
```

4. **ブラウザで確認**

```
http://localhost:4000/r2-oas/
```

### よく使うコマンド

```bash
# ビルドのみ実行
bundle exec jekyll build

# 詳細ログ付きビルド
bundle exec jekyll build --verbose

# 増分ビルド（高速化）
bundle exec jekyll build --incremental

# 特定ポートで起動
bundle exec jekyll serve --port 4001
```

## ✅ 貢献フロー

### 1. ブランチを作成

```bash
git checkout -b docs/add-new-feature-guide
```

### 2. ドキュメントを編集

- 既存ファイルを編集、または新規ファイルを作成
- Front Matterを正しく設定
- ローカルでプレビュー確認

### 3. ビルドテストを実行

```bash
bundle exec jekyll build
```

エラーがないことを確認します。

### 4. 変更をコミット

```bash
git add docs/
git commit -m "docs: add new feature guide for XYZ"
```

### 5. プッシュしてPull Requestを作成

```bash
git push origin docs/add-new-feature-guide
```

GitHubでPull Requestを作成し、以下を含めてください：
- 変更内容の説明
- スクリーンショット（UI変更の場合）
- 関連するIssue番号

## 📋 貢献チェックリスト

新しいドキュメントを追加する際は、以下を確認してください：

- [ ] Front Matterが正しく設定されている
- [ ] `permalink` がSEOフレンドリーである
- [ ] `parent` と `nav_order` が適切に設定されている
- [ ] Calloutボックスが正しい記法を使用している（`{: .note }`, `{: .warning }`）
- [ ] コードブロックに言語指定がある（```ruby, ```bash など）
- [ ] 内部リンクが `{{ site.baseurl }}` を使用している
- [ ] ローカルビルドが成功する
- [ ] ブラウザでプレビュー確認済み

## 🚀 デプロイ

ドキュメントは `master` ブランチにマージされると、GitHub Pagesで自動的にビルド・デプロイされます。

詳細は `DEPLOYMENT_CHECKLIST.md` を参照してください。

## 🐛 トラブルシューティング

### ビルドエラーが発生する

```bash
# 詳細ログを確認
bundle exec jekyll build --verbose --trace
```

よくあるエラー：
- Front MatterのYAML構文エラー → インデントを確認
- Liquidタグのエラー → 閉じタグを確認
- プラグインエラー → `_config.yml` のプラグイン設定を確認

### リンク切れがある

```bash
# HTML Prooferでリンク検証（オプション）
bundle exec htmlproofer _site --assume-extension --check-html
```

### スタイルが正しく適用されない

- ブラウザのキャッシュをクリア
- `bundle exec jekyll clean` で一時ファイルを削除
- 再ビルド

## 📞 サポート

質問や問題がある場合は、以下の方法でサポートを受けられます：

- **GitHub Issues**: https://github.com/yukihirop/r2-oas/issues
- **Pull Request**: 直接修正を提案

## 📚 参考リソース

- [Jekyll公式ドキュメント](https://jekyllrb.com/docs/)
- [Just-the-Docs テーマ](https://just-the-docs.com/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)
- [GitHub Pages ドキュメント](https://docs.github.com/pages)

---

**最終更新日**: 2025-10-30
