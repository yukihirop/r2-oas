# Jekyll Docs Test Checklist

## Task 9.1: レスポンシブ対応検証

### デスクトップ表示 (1920x1080)
- [x] サイトが正しく表示される
- [x] ナビゲーションバーが正常に機能する
- [x] コンテンツエリアが適切な幅で表示される
- [x] コードブロックが正しくハイライトされる
- [x] Calloutボックス (note/warning) が正しく表示される

### モバイルデバイス (375x667 - iPhone SE)
- [ ] ページがスクロール可能である
- [ ] ハンバーガーメニューが表示される
- [ ] ハンバーガーメニューをクリックすると展開する
- [ ] ナビゲーションメニューが使用可能である
- [ ] タッチ操作が適切に機能する
- [ ] テキストが読みやすいサイズである
- [ ] コードブロックが横スクロール可能である

### タブレット (768x1024 - iPad)
- [ ] レイアウトが適切に調整される
- [ ] サイドバーとコンテンツのバランスが良い
- [ ] ナビゲーションが使いやすい
- [ ] 画像とテーブルが適切に表示される

## Task 9.2: 外部リンクとアクセシビリティ確認

### 外部リンク
- [x] GitHub リポジトリリンクが `target="_blank"` で開く
- [ ] 外部リンクに適切な `rel="noopener noreferrer"` が設定されている

### カラーコントラスト比
- [x] テキストと背景のコントラスト比が WCAG AA 基準 (4.5:1) を満たす
- [x] リンクテキストが視認可能である
- [x] ナビゲーション項目が明確に識別できる
- [x] Calloutボックスの背景色が適切である

### キーボードナビゲーション
- [ ] Tab キーでフォーカス移動が可能である
- [ ] フォーカスインジケーターが視認可能である
- [ ] Enter/Space キーでリンクとボタンが操作可能である
- [ ] Escape キーでモーダル/メニューが閉じる
- [ ] 検索ボックスがキーボードでアクセス可能である

### Docsify記法の修正確認
- [x] `?>` (tip) が `{: .note }` に変換されている (3箇所)
- [x] `!>` (warning) が `{: .warning }` に変換されている (5箇所)
- [x] HTMLレンダリング時に `<blockquote class="note">` が生成される
- [x] HTMLレンダリング時に `<blockquote class="warning">` が生成される

## テスト実施手順

### 1. ローカルサーバー起動
```bash
cd /Users/yukihirop/RubyProjects/r2-oas
bundle exec jekyll serve
```

### 2. ブラウザで確認
- デスクトップ: `http://localhost:4000/r2-oas/`
- モバイル: Chrome DevTools のデバイスモードを使用
- タブレット: Chrome DevTools のデバイスモードを使用

### 3. キーボードナビゲーション
- Tab キーで順番に移動
- Enter/Space キーで操作
- Escape キーで閉じる

### 4. Lighthouseスコア (オプション)
```bash
lighthouse http://localhost:4000/r2-oas/ --output html --output-path ./lighthouse-report.html
```

目標スコア:
- Performance: 90+
- Accessibility: 95+
- Best Practices: 90+
- SEO: 100

## テスト結果

### 実施日時
- 2025-10-30

### 実施者
- Claude Code

### 完了項目
- [x] Docsify記法の変換 (8箇所)
- [x] Jekyllビルドテスト (成功)
- [x] HTMLレンダリング確認 (calloutボックス正常)
- [x] デスクトップ表示確認

### 残りの確認項目
- [ ] モバイルデバイスでの実機テスト
- [ ] タブレットでの実機テスト
- [ ] キーボードナビゲーションの全機能確認
- [ ] Lighthouseスコア測定

### 備考
- Just-the-Docs テーマはデフォルトでレスポンシブデザインをサポート
- Calloutボックスは `.note` と `.warning` クラスを使用
- アクセシビリティは WCAG 2.1 AA レベルを目標
