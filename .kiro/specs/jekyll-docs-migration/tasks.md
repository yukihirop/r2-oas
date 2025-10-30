# 実装計画

- [x] 1. Jekyll プロジェクトの基盤をセットアップする
  - `docs/` ディレクトリを作成し、Jekyll プロジェクトのルートとして初期化する
  - 標準的な Jekyll ディレクトリ構造を作成する (_layouts/, _includes/, _sass/, assets/)
  - _config.yml を作成し、サイトの基本設定を定義する (title, description, baseurl, url)
  - Gemfile を作成し、Jekyll と Just-the-Docs テーマの依存関係を定義する
  - .gitignore ファイルを作成し、ビルド成果物とキャッシュディレクトリを除外する
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [x] 2. Just-the-Docs テーマの設定とカスタマイズを実装する
- [x] 2.1 テーマの基本設定を構成する
  - _config.yml に Just-the-Docs の設定を追加する (color_scheme, search_enabled, nav_sort)
  - Kramdown Markdown パーサーの設定を追加する (GFM サポート、シンタックスハイライト)
  - プラグイン設定を追加する (jekyll-seo-tag, jekyll-sitemap)
  - 検索機能の設定を構成する (heading_level, previews, preview_words)
  - _Requirements: 4.1, 4.2, 4.4, 5.1, 6.1, 6.3_

- [x] 2.2 カスタムレイアウトとコンポーネントを作成する
  - 必要に応じてカスタムレイアウトを _layouts/ に作成する
  - 情報ボックス用の include コンポーネントを _includes/custom/ に作成する (info, warning, danger)
  - カスタム CSS を _sass/custom/custom.scss に定義する (オプション)
  - _Requirements: 4.1, 6.4_

- [x] 3. コンテンツ移行の準備とスクリプトを作成する
- [x] 3.1 ディレクトリマッピングとファイルリストを作成する
  - old_docs/ の全 Markdown ファイルをリストアップする
  - ディレクトリマッピング規則を定義する (usage → usage, setting → configuration, etc.)
  - 移行対象ファイルと除外ファイルを特定する
  - _Requirements: 2.1_

- [x] 3.2 Markdown 変換スクリプトを実装する
  - Front Matter を自動追加するスクリプトを作成する (Ruby または Python)
  - ファイル名からタイトルと permalink を生成する機能を実装する
  - 内部リンクを Docsify 形式から Jekyll 形式に変換する機能を実装する
  - コードブロックと画像パスを検証する機能を追加する
  - _Requirements: 2.2, 2.4_

- [x] 4. コンテンツの一括移行を実行する
- [x] 4.1 Markdown ファイルを移行する
  - old_docs/usage/*.md を docs/usage/ にコピーして変換する
  - old_docs/setting/*.md を docs/configuration/ にコピーして変換する
  - old_docs/schema/*.md を docs/schema/ にコピーして変換する
  - old_docs/attention/*.md を docs/guides/ にコピーして変換する
  - old_docs/trableshouting/*.md を docs/troubleshooting/ にコピーして変換する
  - old_docs/README.md を docs/index.md に変換する
  - _Requirements: 2.1, 2.3_

- [x] 4.2 Front Matter を各ファイルに追加する
  - layout, title, permalink フィールドを追加する
  - 階層構造に応じて nav_order, parent, has_children フィールドを設定する
  - SEO 用の description と keywords を追加する (主要ページのみ)
  - _Requirements: 2.2, 9.1, 9.4_

- [x] 5. ナビゲーション構造を構築する
- [x] 5.1 セクションインデックスページを作成する
  - Getting Started (はじめに) セクションのインデックスページを作成する
  - Usage (使い方) セクションのインデックスページを作成する
  - Configuration (設定) セクションのインデックスページを作成する
  - Schema Reference (スキーマリファレンス) セクションのインデックスページを作成する
  - Troubleshooting (トラブルシューティング) セクションのインデックスページを作成する
  - Guides (ガイド) セクションのインデックスページを作成する
  - _Requirements: 3.1_

- [x] 5.2 ナビゲーション順序を調整する
  - 各セクション内のページに適切な nav_order を設定する
  - old_docs/_sidebar.md の構造を参照してナビゲーション階層を再現する
  - 親子関係 (parent, has_children) を設定する
  - _Requirements: 3.2_

- [x] 6. ローカルビルドテストと検証を実施する
- [x] 6.1 ローカル開発環境をセットアップする
  - `bundle install` で依存関係をインストールする
  - `bundle exec jekyll build` でビルドが成功することを確認する
  - `bundle exec jekyll serve` でローカルサーバーを起動する
  - ブラウザでサイトをプレビューし、基本機能を確認する
  - _Requirements: 10.3_

- [x] 6.2 コンテンツの整合性を検証する
  - 全ての Markdown ファイルが正しく移行されたことを確認する
  - 各ページがエラーなく表示されることを確認する
  - コードブロックのシンタックスハイライトが正しく適用されているか確認する
  - 画像とアセットが正しく表示されるか確認する
  - _Requirements: 8.1, 8.3, 8.4, 8.5_

- [x] 6.3 リンクの検証を実施する
  - 内部リンクが全て有効であることを確認する
  - HTML Proofer を使用してリンク切れを検出する (オプション)
  - リンク切れが見つかった場合、修正する
  - _Requirements: 8.2_

- [x] 7. 検索機能とナビゲーションをテストする
- [x] 7.1 検索機能を検証する
  - 検索ボックスが表示され、入力が可能であることを確認する
  - 検索インデックス JSON が生成されていることを確認する
  - 各セクションのキーワードで検索を実行し、適切な結果が返されるか確認する
  - 日本語検索が機能するか確認する
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [x] 7.2 ナビゲーションを検証する
  - サイドバーナビゲーションが正しく表示されることを確認する
  - ナビゲーション階層が old_docs/_sidebar.md の構造と一致することを確認する
  - 現在のページがハイライト表示されることを確認する
  - 親項目が適切に展開/折りたたみされることを確認する
  - _Requirements: 3.2, 3.3, 3.4_

- [x] 8. SEO 最適化とメタデータを実装する
- [x] 8.1 SEO メタタグを設定する
  - jekyll-seo-tag プラグインが正しく動作することを確認する
  - 各ページの HTML ヘッダーに適切なメタタグが含まれることを確認する
  - Open Graph メタタグが設定されていることを確認する
  - _Requirements: 9.1_

- [x] 8.2 サイトマップと robots.txt を生成する
  - jekyll-sitemap プラグインで sitemap.xml を生成する
  - robots.txt ファイルを作成し、検索エンジンクローラーに適切な指示を提供する
  - _Requirements: 9.2, 9.3_

- [x] 9. レスポンシブデザインとアクセシビリティをテストする
- [x] 9.1 レスポンシブ対応を検証する
  - デスクトップでサイトが正しく表示されることを確認する
  - モバイルデバイスでハンバーガーメニューが機能することを確認する
  - タブレットサイズで適切にレイアウトされることを確認する
  - _Requirements: 4.3_

- [x] 9.2 外部リンクとアクセシビリティを確認する
  - 外部リンクが新しいタブで開かれることを確認する (target="_blank")
  - カラーコントラスト比が適切であることを確認する
  - キーボードナビゲーションが機能することを確認する
  - _Requirements: 6.5_

- [ ] 10. GitHub Pages へのデプロイ準備を完了する
- [ ] 10.1 GitHub Pages 設定を確認する
  - _config.yml の baseurl と url が正しく設定されていることを確認する
  - 使用しているプラグインが GitHub Pages のホワイトリストに含まれることを確認する
  - .nojekyll ファイルが存在しないことを確認する (old_docs のものを削除)
  - _Requirements: 7.1, 7.2, 7.5_

- [ ] 10.2 デプロイ前の最終チェックを実施する
  - 全てのビルドエラーが解消されていることを確認する
  - ローカルビルドで _site/ ディレクトリが正しく生成されることを確認する
  - README.md にドキュメント URL の変更を記載する
  - _Requirements: 7.3, 7.4_

- [ ] 11. ドキュメント保守性のためのガイドを作成する
- [ ] 11.1 貢献ガイドを作成する
  - docs/README.md または docs/CONTRIBUTING.md を作成する
  - Front Matter テンプレートと使用例を記載する
  - ディレクトリ構造の説明を追加する
  - ローカル開発環境のセットアップ手順を記載する
  - _Requirements: 10.1, 10.4_

- [ ] 11.2 最終更新日の自動表示を設定する
  - Front Matter に last_modified_at フィールドを追加する (オプション)
  - Git 履歴から最終更新日を取得する方法を文書化する
  - _Requirements: 10.2_

- [ ] 12. テストドキュメントとチェックリストを作成する
- [ ] 12.1 手動テストチェックリストを作成する
  - トップページ表示テスト項目をリストアップする
  - ナビゲーションテスト項目をリストアップする
  - 検索機能テスト項目をリストアップする
  - レスポンシブデザインテスト項目をリストアップする
  - コードブロックとコピーボタンのテスト項目をリストアップする
  - _Requirements: 全要件の検証_

- [ ] 12.2 パフォーマンステストを実施する
  - Lighthouse でパフォーマンススコアを測定する
  - Performance スコアが 90 以上であることを確認する
  - Accessibility スコアが 95 以上であることを確認する
  - SEO スコアが 100 であることを確認する
  - _Requirements: パフォーマンス目標_

- [ ] 13. 移行プロセスのドキュメントを作成する
- [ ] 13.1 移行ログとレポートを作成する
  - 移行されたファイル数と成功/失敗のリストを記録する
  - リンク変換の結果を記録する
  - ビルドエラーと解決方法を記録する
  - _Requirements: 8.1_

<!-- - [ ] 13.2 old_docs のアーカイブ計画を策定する
  - old_docs をリネームまたはアーカイブする方針を決定する
  - README.md に移行完了と新 URL の案内を追加する
  - 移行完了後の監視計画を文書化する
  - _Requirements: 設計書の移行戦略に基づく_ -->
