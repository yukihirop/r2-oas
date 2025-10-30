# GitHub Pages デプロイチェックリスト

## Task 10.1: GitHub Pages設定確認

### _config.yml設定
- [x] `baseurl: "/r2-oas"` が正しく設定されている
- [x] `url: "https://yukihirop.github.io"` が正しく設定されている
- [x] テーマが `just-the-docs` に設定されている

### プラグイン確認
- [x] `jekyll-seo-tag` - GitHub Pagesホワイトリスト対象 ✅
- [x] `jekyll-sitemap` - GitHub Pagesホワイトリスト対象 ✅
- [x] カスタムプラグインは使用していない

### .nojekyllファイル
- [x] `docs/.nojekyll` は存在しない（Jekyllビルドが有効）
- [x] `old_docs/.nojekyll` は残す（Docsify用、参照用として保持）

## Task 10.2: デプロイ前の最終チェック

### ビルド検証
- [x] `bundle exec jekyll build` がエラーなく完了
- [x] ビルド時間: 0.98秒
- [x] 警告やエラーメッセージなし

### 生成ファイル確認
- [x] `docs/_site/index.html` が生成されている
- [x] `docs/_site/sitemap.xml` が生成されている
- [x] `docs/_site/robots.txt` が生成されている
- [x] 全セクションのHTML (`usage/`, `configuration/`, etc.) が生成されている

### ドキュメント更新
- [x] `README.md` にドキュメントURL記載済み
  - URL: `https://yukihirop.github.io/r2-oas`
- [x] 既存のURLと一致している（変更不要）

## GitHub Pagesデプロイ設定手順

### デプロイ方法の選択

2つのデプロイ方法があります：

1. **GitHub Actions（推奨）** - 自動デプロイ、カスタムビルドプロセス対応
2. **Branch から直接デプロイ** - シンプル、従来の方法

---

## 方法1: GitHub Actions で自動デプロイ（推奨）

### 1. GitHubリポジトリ設定

#### Settings > Pages
```
Source:
  GitHub Actions を選択
```

**手順**:
1. GitHubリポジトリページを開く
2. **Settings** タブをクリック
3. 左サイドバーから **Pages** を選択
4. **Source** セクションで **GitHub Actions** を選択
5. 「Save」をクリック

### 2. GitHub Actions ワークフロー確認

ワークフローファイルが存在することを確認：
```bash
ls -la .github/workflows/jekyll-deploy.yml
```

**ワークフローの内容**:
- トリガー: `master` ブランチへのプッシュ（`docs/` 配下の変更時）
- ビルド: Jekyll サイトをビルド
- デプロイ: GitHub Pages に自動デプロイ

### 3. 変更のコミットとプッシュ

```bash
# 現在の作業ディレクトリ
cd /Users/yukihirop/RubyProjects/r2-oas

# ステータス確認
git status

# 変更をステージング
git add docs/ .github/workflows/jekyll-deploy.yml

# コミット
git commit -m "feat: add GitHub Actions workflow for Jekyll deployment

- Add .github/workflows/jekyll-deploy.yml
- Configure automatic deployment to GitHub Pages
- Set up build and deploy jobs with proper permissions

Related: jekyll-docs-migration spec task 13.2"

# プッシュ
git push origin master
```

### 4. GitHub Actions ワークフロー実行確認

1. GitHubリポジトリページを開く
2. **Actions** タブをクリック
3. 「Deploy Jekyll Documentation to GitHub Pages」ワークフローを確認
4. 実行中のワークフローをクリックして進行状況を確認
5. ビルドとデプロイが成功することを確認（✅ 緑のチェックマーク）

**ワークフローの流れ**:
```
1. Checkout repository
2. Setup Ruby (3.2)
3. Install dependencies (bundle install)
4. Build Jekyll site
5. Upload artifact
6. Deploy to GitHub Pages
```

### 5. デプロイ確認

ビルド完了後（通常1-2分）、以下にアクセス：
```
https://yukihirop.github.io/r2-oas/
```

### GitHub Actions のメリット

- ✅ **自動デプロイ**: master ブランチにプッシュするだけで自動デプロイ
- ✅ **カスタムビルド**: 任意のRubyバージョンやプラグインを使用可能
- ✅ **ビルドログ**: Actions タブで詳細なビルドログを確認可能
- ✅ **高速**: 並列ビルドとキャッシュで高速化
- ✅ **柔軟性**: ビルド前後に任意のスクリプトを実行可能

---

## 方法2: Branch から直接デプロイ（従来の方法）

### 1. GitHubリポジトリ設定

#### Settings > Pages
```
Source:
  Branch: master (または main)
  Folder: /docs
```

### 2. 変更のコミットとプッシュ

```bash
# 現在の作業ディレクトリ
cd /Users/yukihirop/RubyProjects/r2-oas

# ステータス確認
git status

# 変更をステージング
git add docs/

# コミット
git commit -m "feat: complete Jekyll documentation migration

- Migrate from Docsify to Jekyll + Just-the-Docs theme
- Convert Docsify syntax (?>, !>) to Jekyll callouts
- Fix code block rendering issues
- Add responsive design and accessibility support
- Configure GitHub Pages deployment

Tasks completed: 1-10 (76.9% complete)
Related: jekyll-docs-migration spec"

# プッシュ
git push origin <branch-name>
```

### 3. GitHub Pagesビルド確認（Branch デプロイの場合）

1. GitHubリポジトリの **Settings > Pages** を開く
2. ビルドステータスを確認
3. ビルド完了後、`https://yukihirop.github.io/r2-oas/` にアクセス

---

## ビルドエラー時の対処

### GitHub Actions の場合

**エラー確認手順**:
1. GitHubリポジトリの **Actions** タブを開く
2. 失敗したワークフロー（❌ 赤いX）をクリック
3. 失敗したジョブをクリック
4. エラーログを確認

**よくあるエラーと対処法**:

| エラー | 原因 | 解決方法 |
|-------|------|---------|
| `bundle install` 失敗 | Gemfile.lock の依存関係エラー | ローカルで `bundle install` 実行後、Gemfile.lock をコミット |
| Jekyll ビルドエラー | Markdown構文エラー、Front Matterエラー | エラーログで該当ファイルを特定し修正 |
| 権限エラー | Pages の write 権限がない | Settings > Actions > General で Workflow permissions を確認 |
| デプロイ失敗 | GitHub Pages が無効 | Settings > Pages で GitHub Actions が選択されているか確認 |

**デバッグ手順**:
```bash
# ローカルで同じビルドコマンドを実行
cd docs
bundle install
bundle exec jekyll build --baseurl "/r2-oas"

# エラーが再現すれば、ローカルで修正可能
```

### Branch デプロイの場合

**エラー確認**:
- GitHubからのメール通知を確認
- Settings > Pages でビルドエラーメッセージを確認

**よくあるエラー**:
- プラグインがホワイトリスト外 → サポートされるプラグインに変更
- `_config.yml` の構文エラー → YAMLバリデータで検証
- Front Matter エラー → Markdownファイルを確認

## デプロイ後の確認事項

### 基本動作確認
- [ ] トップページが表示される
- [ ] ナビゲーションが機能する
- [ ] 検索機能が動作する
- [ ] 全てのページが正しく表示される

### スタイル確認
- [ ] Calloutボックス（note/warning）が正しく表示される
- [ ] コードブロックが正しくハイライトされる
- [ ] レスポンシブデザインが機能する（モバイル/タブレット）

### SEO確認
- [ ] `sitemap.xml` にアクセス可能
- [ ] `robots.txt` にアクセス可能
- [ ] Open Graphメタタグが設定されている

### リンク確認
- [ ] 内部リンクが全て有効
- [ ] 外部リンク（GitHub）が新しいタブで開く
- [ ] 画像が正しく表示される

## ロールバック手順

問題が発生した場合:

```bash
# 以前のコミットに戻す
git revert <commit-hash>
git push origin <branch-name>

# または、一時的にold_docsに戻す（GitHub設定で変更）
# Settings > Pages > Source > Folder: /old_docs
```

## 監視とメンテナンス

### 定期確認
- **毎月**: 依存関係更新 (`bundle update`)
- **四半期ごと**: ドキュメントレビューと更新
- **半年ごと**: パフォーマンス測定と最適化

### Google Search Console設定
1. https://search.google.com/search-console にアクセス
2. サイトマップを登録: `https://yukihirop.github.io/r2-oas/sitemap.xml`
3. インデックス状況を監視

## 完了ステータス

- ✅ Task 10.1: GitHub Pages設定確認 - **完了**
- ✅ Task 10.2: デプロイ前の最終チェック - **完了**
- ✅ Task 13.2: GitHub Actions自動デプロイ設定 - **完了**
- 🚀 **推奨**: GitHub Actions を使った自動デプロイを使用

---

**作成日**: 2025-10-30
**最終更新**: 2025-10-30
