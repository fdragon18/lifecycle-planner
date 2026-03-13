# ライフサイクルプランニングシート

サイグラム（数秘術）ベースのライフサイクル分析Webアプリ。

## 機能

- 生年月日から60類型番号・個性番号・SPを計算
- 年サイクル（10年分）のグラフ表示
- 月サイクル分析
- TC年/TC月のハイライト表示
- サイクル別の行動アドバイス表示

## 認証・履歴機能 (v4.0)

- メール/パスワードでのユーザー登録・ログイン
- 検索履歴の保存・読み込み・削除
- 名前を付けて検索を保存可能

## 使い方

1. https://fdragon18.github.io/lifecycle-planner/ にアクセス
2. 生年月日を入力
3. 「年分析」または「月分析」ボタンをクリック
4. （オプション）アカウント作成で検索履歴を保存

## 技術スタック

- HTML/CSS/JavaScript
- Supabase (認証・データベース)
- GitHub Pages

## ローカル開発

```bash
# リポジトリをクローン
git clone https://github.com/fdragon18/lifecycle-planner.git
cd lifecycle-planner

# ローカルサーバーで起動
python3 -m http.server 8000
# または
npx serve .
```

http://localhost:8000 でアクセス

## ライセンス

Private
