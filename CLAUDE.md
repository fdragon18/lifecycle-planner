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
- Supabase認証（メール/パスワード）
- Supabase Database（検索履歴保存、RLS有効）

## ファイル構成

```
lifecycle-planner/
├── CLAUDE.md            # このファイル
├── index.html           # メインアプリ (v4.0)
├── cycle_data.json      # サイクル別行動一覧（239エントリー）
├── supabase_setup.sql   # Supabaseテーブル作成SQL
└── docs/
    ├── ANALYSIS.md      # Excel解析ドキュメント
    └── tables.json      # 計算テーブル（60類型等）
```

## 計算ロジック（解析完了）

### 1. 60類型番号
生年月日のExcelシリアル日付から計算。

```javascript
const serialDate = excelSerialDate(birthYear, birthMonth, birthDay);
const typeNumber60 = ((serialDate + 8) % 60) + 1;  // 1-60
```

### 2. 個性番号（1-12）
60類型番号からルックアップテーブルで取得。

```javascript
const PERSONALITY_TABLE = [
    5,4,8,6,3,11,5,4,8,6,1,7,9,2,8,6,1,7,9,2,
    12,12,2,9,9,2,12,12,2,9,7,1,6,8,2,9,7,1,6,8,
    4,5,11,3,6,8,4,5,11,3,10,10,3,11,11,3,10,10,3,11
];
const personalityNumber = PERSONALITY_TABLE[typeNumber60 - 1];
```

#### 60類型番号・日干支・個性番号 対応表

60類型番号は日干支（六十干支）に対応している。

| 60類型 | 日干支 | 個性 | | 60類型 | 日干支 | 個性 | | 60類型 | 日干支 | 個性 |
|--------|--------|------|---|--------|--------|------|---|--------|--------|------|
| 1 | 甲子 | 5 | | 21 | 甲申 | 12 | | 41 | 甲辰 | 4 |
| 2 | 乙丑 | 4 | | 22 | 乙酉 | 12 | | 42 | 乙巳 | 5 |
| 3 | 丙寅 | 8 | | 23 | 丙戌 | 2 | | 43 | 丙午 | 11 |
| 4 | 丁卯 | 6 | | 24 | 丁亥 | 9 | | 44 | 丁未 | 3 |
| 5 | 戊辰 | 3 | | 25 | 戊子 | 9 | | 45 | 戊申 | 6 |
| 6 | 己巳 | 11 | | 26 | 己丑 | 2 | | 46 | 己酉 | 8 |
| 7 | 庚午 | 5 | | 27 | 庚寅 | 12 | | 47 | 庚戌 | 4 |
| 8 | 辛未 | 4 | | 28 | 辛卯 | 12 | | 48 | 辛亥 | 5 |
| 9 | 壬申 | 8 | | 29 | 壬辰 | 2 | | 49 | 壬子 | 11 |
| 10 | 癸酉 | 6 | | 30 | 癸巳 | 9 | | 50 | 癸丑 | 3 |
| 11 | 甲戌 | 1 | | 31 | 甲午 | 7 | | 51 | 甲寅 | 10 |
| 12 | 乙亥 | 7 | | 32 | 乙未 | 1 | | 52 | 乙卯 | 10 |
| 13 | 丙子 | 9 | | 33 | 丙申 | 6 | | 53 | 丙辰 | 3 |
| 14 | 丁丑 | 2 | | 34 | 丁酉 | 8 | | 54 | 丁巳 | 11 |
| 15 | 戊寅 | 8 | | 35 | 戊戌 | 2 | | 55 | 戊午 | 11 |
| 16 | 己卯 | 6 | | 36 | 己亥 | 9 | | 56 | 己未 | 3 |
| 17 | 庚辰 | 1 | | 37 | 庚子 | 7 | | 57 | 庚申 | 10 |
| 18 | 辛巳 | 7 | | 38 | 辛丑 | 1 | | 58 | 辛酉 | 10 |
| 19 | 壬午 | 9 | | 39 | 壬寅 | 6 | | 59 | 壬戌 | 3 |
| 20 | 癸未 | 2 | | 40 | 癸卯 | 8 | | 60 | 癸亥 | 11 |

### 3. SP（1-10）
**60類型番号の下1桁**（ExcelのRIGHT関数に相当）

```javascript
const sp = typeNumber60 % 10 || 10;  // 0の場合は10
```

例:
- 60類型番号 13 → SP 3
- 60類型番号 57 → SP 7
- 60類型番号 10 → SP 10

### 4. 派
個性番号の奇数/偶数で決定。

```javascript
const faction = (personalityNumber % 2 === 1) ? "楽観派" : "慎重派";
```

### 5. タイプコード
個性番号から決定（F=前進型, A=調和型, M=堅実型、★=楽観派, ☆=慎重派）

```javascript
const TYPE_MAPPING = {
    1: 'F★', 2: 'F☆', 3: 'A★', 4: 'A☆', 5: 'M★', 6: 'M☆',
    7: 'A★', 8: 'A☆', 9: 'M★', 10: 'M☆', 11: 'F★', 12: 'F☆'
};
```

### 6. 年サイクル（A-G, X-Z）

#### サイクルテーブル（SP別）
SPの値（1-10）に対応する10年分のサイクル順序。
2026年（年末尾6）を基準としたテーブル。

```javascript
const SP_CYCLE_TABLE = {
    1: ['C', 'D', 'E', 'F', 'G', 'X', 'Y', 'Z', 'A', 'B'],
    2: ['D', 'C', 'F', 'E', 'X', 'G', 'Z', 'Y', 'B', 'A'],
    3: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'X', 'Y', 'Z'],
    4: ['B', 'A', 'D', 'C', 'F', 'E', 'X', 'G', 'Z', 'Y'],
    5: ['Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'X'],
    6: ['Z', 'Y', 'B', 'A', 'D', 'C', 'F', 'E', 'X', 'G'],
    7: ['G', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D', 'E', 'F'],
    8: ['X', 'G', 'Z', 'Y', 'B', 'A', 'D', 'C', 'F', 'E'],
    9: ['E', 'F', 'G', 'X', 'Y', 'Z', 'A', 'B', 'C', 'D'],
    10: ['F', 'E', 'X', 'G', 'Z', 'Y', 'B', 'A', 'D', 'C']
};
```

#### サイクル取得ロジック

```javascript
function getCycle(sp, targetYear) {
    const spKey = sp % 10 || 10;
    const cycles = SP_CYCLE_TABLE[spKey];
    const yearDigit = targetYear % 10;
    const index = (yearDigit + 4) % 10;  // 年末尾6→index 0
    return cycles[index];
}
```

### 7. グラフY値
サイクル文字に対応するグラフの高さ（Excelの基本グラフシートから抽出）。

```javascript
const CYCLE_VALUES = {
    'A': 4, 'B': 2, 'C': 6, 'D': 5, 'E': 8,
    'F': 9, 'G': 8, 'X': 10, 'Y': 3, 'Z': 4
};
```

## VBAマクロの構造

### 年分析マクロの流れ

1. **入力**: 生年月日(B4-D4)、起点年月日(B5-D5)
2. **分析1シートで計算**:
   - B3: 生年月日シリアル値
   - G3: 60類型番号 = `MOD(B3+8, 60)+1`
   - H3: SP = `RIGHT(G3, 1)`（下1桁）
   - E3: 個性番号（ルックアップ）
3. **ライフサイクルマスタ（年）でサイクル取得**:
   - 行検索: A32:K41でSP値を検索
   - 列検索: B6:K30で起点年シリアル値を検索
   - 交点から右に10個のサイクル文字を取得

## 未実装

- [ ] 月サイクル計算（ライフサイクルマスタ（月）使用）
- [ ] 日サイクル計算（ライフサイクルマスタ（日）使用）

## Supabase連携 (v4.0)

### プロジェクト情報
- URL: `https://vwcetyahgnqfrqlgnelx.supabase.co`
- 認証方式: メール/パスワード

### データベース構造

```sql
-- 検索履歴テーブル
CREATE TABLE searches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,                    -- 検索の名前（任意）
  birth_year INT NOT NULL,
  birth_month INT NOT NULL,
  birth_day INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Row Level Security (RLS)
- 有効化済み
- ユーザーは自分のデータのみ参照・追加・削除可能

### 機能
- ログイン/サインアップ/ログアウト
- 検索履歴の保存（名前付け可能）
- 履歴からの読み込み
- 履歴の削除

## バージョン履歴

- v4.0: Supabase認証・検索履歴機能
- v3.0: TC年計算修正（12年周期）
- v2.0: 月分析機能追加
- v1.0: 初期リリース

## 開発メモ

- GitHub: fdragon18 アカウント
- 元Excelファイル: `/Users/ddra/Downloads/ライフサイクルプランニングシート _170608.xlsm`
