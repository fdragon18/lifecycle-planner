# Lifecycle Planner

## プロジェクト概要

サイグラム（数秘術）ベースのライフサイクル分析Webアプリ。
元のExcelマクロ（`ライフサイクルプランニングシート _170608.xlsm`）をWeb化。

## 目的

- Excelマクロが動かない問題を解消
- 誰でもフランクに使えるWeb版を提供
- GitHub Pagesで無料ホスティング（fdragon18アカウント）

## 技術スタック

- 静的HTML/CSS/JavaScript（フレームワークなし）
- GitHub Pages でホスティング
- 簡易パスワード認証（セッションストレージ）

## ファイル構成

```
lifecycle-planner/
├── CLAUDE.md            # このファイル
├── index.html           # メインアプリ
├── cycle_data.json      # サイクル別行動一覧（239エントリー）
└── docs/
    ├── ANALYSIS.md      # Excel解析ドキュメント
    └── tables.json      # 計算テーブル（60類型等）
```

## 計算ロジック（解析済み）

### 1. 60類型番号
```javascript
const serialDate = excelSerialDate(birthYear, birthMonth, birthDay);
const typeNumber = ((serialDate + 8) % 60) + 1;  // 1-60
```

### 2. 個性番号・SP
`docs/tables.json` の `personality_table` と `sp_table` を使用。

### 3. 派
```javascript
const faction = (personalityNumber % 2 === 1) ? "楽観派" : "慎重派";
```

### 4. タイプコード
個性番号と年齢からタイプ（F★, A☆, Mc等）を決定。
詳細は `docs/ANALYSIS.md` 参照。

## 未解決事項

- [ ] 個性番号→タイプの正確なマッピング
- [ ] サイクル順序の決定ロジック（起点年・個性番号から）
- [ ] サイクルの数値（D〜Zのグラフ値）
- [ ] 月サイクル・日サイクルの計算

## 元Excelの参照

元ファイル: `/Users/ddra/Downloads/ライフサイクルプランニングシート _170608.xlsm`
展開先: `/tmp/lifecycle_sheet/`

## 開発メモ

- パスワード: `lifecycle2024`（index.html内で設定）
- 利用者: 約10人、週10回/人程度の想定
- GitHub: fdragon18 アカウントで公開予定
