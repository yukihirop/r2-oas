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

### 3. GitHub Pagesビルド確認

1. GitHubリポジトリの **Settings > Pages** を開く
2. ビルドステータスを確認
3. ビルド完了後、`https://yukihirop.github.io/r2-oas/` にアクセス

### 4. ビルドエラー時の対処

**エラー確認**:
- GitHubからのメール通知を確認
- Actions タブでビルドログを確認

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
- ⏳ **次のステップ**: GitHubにプッシュしてデプロイ

---

**作成日**: 2025-10-30
**最終更新**: 2025-10-30
