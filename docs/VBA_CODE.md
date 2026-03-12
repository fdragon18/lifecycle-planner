# VBAマクロ コード

抽出日: 2026-03-12
ツール: olevba

---

## Module1 - 年分析

```vba
Sub 年分析()

 Dim Sh1 As Worksheet  ' ライフサイクル分析シート
 Dim Sh2 As Worksheet  ' 分析1
 Dim Sh3 As Worksheet  ' 基本グラフ
 Dim Sh4 As Worksheet  ' TC年
 Dim Sh7 As Worksheet  ' ライフサイクルマスタ（年）

 ' 入力チェック
 If Sh1.Range("B4").Value = "" Then
    MsgBox "生年月日が未入力です!", vbCritical
    Exit Sub
 End If
 ' ... (C4, D4, B5, C5, D5 も同様にチェック)

 ' 背景色リセット
 Sh1.Range("G2:P7").Interior.Color = RGB(217, 217, 217)
 Sh1.Range("G8:P16").Interior.Color = RGB(252, 228, 214)
 Sh1.Range("G17:P37").Interior.Color = RGB(255, 255, 255)
 Sh1.Range("G38:P46").Interior.Color = RGB(221, 235, 247)

 ' 日付値を設定
 Sh2.Range("B3").Value = Sh2.Range("A3").Value  ' 生年月日
 Sh2.Range("B5").Value = Sh2.Range("A5").Value  ' 起点年
 Sh7.Range("B2").Value = Sh2.Range("B5").Value  ' 起点年をマスタに設定
 Sh7.Range("B3").Value = Sh2.Range("H3").Value  ' SP値をマスタに設定

 ' 年列のヘッダー設定（10年分）
 Sh1.Range("F2").Value = "年"
 Sh1.Range("G2:P2").NumberFormatLocal = "yyyy" & "年"
 Sh1.Range("G2").Value = Sh2.Range("B5").Value
 Sh1.Range("H2").Value = DateAdd("m", 12, Sh1.Range("G2"))
 Sh1.Range("I2").Value = DateAdd("m", 12, Sh1.Range("H2"))
 ' ... (10年分)

 ' ★ 重要: サイクル文字の取得ロジック
 Dim r As Long, c As Long
 r = Sh7.Range("A32:K41").Find(What:=Sh7.Range("B3")).Row   ' SP値で行を検索
 c = Sh7.Range("B6:K30").Find(What:=Sh7.Range("B2")).Column ' 起点年で列を検索

 ' r行c列から横に10個のサイクル文字を取得
 Sh7.Range("B4") = Sh7.Cells(r, c)
 Sh7.Range("C4") = Sh7.Cells(r, c).Next
 Sh7.Range("D4") = Sh7.Cells(r, c).Next.Next
 Sh7.Range("E4") = Sh7.Cells(r, c).Next.Next.Next
 Sh7.Range("F4") = Sh7.Cells(r, c).Next.Next.Next.Next
 Sh7.Range("G4") = Sh7.Cells(r, c).Next.Next.Next.Next.Next
 Sh7.Range("H4") = Sh7.Cells(r, c).Next.Next.Next.Next.Next.Next
 Sh7.Range("I4") = Sh7.Cells(r, c).Next.Next.Next.Next.Next.Next.Next
 Sh7.Range("J4") = Sh7.Cells(r, c).Next.Next.Next.Next.Next.Next.Next.Next
 Sh7.Range("K4") = Sh7.Cells(r, c).Next.Next.Next.Next.Next.Next.Next.Next.Next

 ' 基本グラフにコピー
 Sh3.Range("B2").Value = Sh7.Range("B4").Value
 ' ... (10個)

 ' TC年でハイライト
 Sh4.Range("B5").Value = Sh2.Range("G3").Value  ' 60類型番号
 Set rng1 = Sh4.Range("D3:D23,G3:G23,...").Find(What:=Sh4.Range("B5").Value)
 ' ...
End Sub
```

---

## Module2 - 月分析

```vba
Sub 月分析()
 ' 年分析とほぼ同じ構造
 ' 違い:
 '   - Sh8 (ライフサイクルマスタ（月）) を使用
 '   - 検索範囲が異なる: A302:K311, B6:K300
 '   - DateAdd("m", 1, ...) で1ヶ月ずつ加算

 r = Sh8.Range("A302:K311").Find(What:=Sh8.Range("B3")).Row
 c = Sh8.Range("B6:K300").Find(What:=Sh8.Range("B2")).Column
 ' ...
End Sub
```

---

## Module4 - 管理用

```vba
Sub 管理用()
  Rows("50:2000").Hidden = True
End Sub
```

---

## Module5 - 保護

```vba
Sub 保護解除()
  Dim W As Worksheet
  For Each W In Worksheets
    W.Unprotect
  Next W
End Sub

Sub 保護()
  If ActiveSheet.ProtectContents = False Then
    Cells.Locked = True
    ActiveSheet.Range("B4:D5").Locked = False
    ActiveSheet.Range("G4:P7").Locked = False
    ActiveSheet.Protect Password:="LEGACY19792519", UserInterfaceOnly:=True
  End If
End Sub
```

**パスワード**: `LEGACY19792519`

---

## 計算ロジックのまとめ

### 年分析

1. **入力値**
   - 生年月日: B4, C4, D4
   - 起点年: B5, C5, D5

2. **計算フロー**
   ```
   生年月日 → 日付シリアル値 (分析1!B3)
   日付シリアル値 → 60類型番号 (分析1!G3)
   60類型番号 → SP (分析1!H3)
   ```

3. **サイクル取得**
   ```
   ライフサイクルマスタ（年）で:
   - 行: SPの値で A32:K41 を検索
   - 列: 起点年で B6:K30 を検索
   - 交点から横に10個のサイクル文字を取得
   ```

4. **出力**
   - B4-K4: サイクル文字（10個）
   - G2-P2: 年（10年分）
   - サイクルコード生成 → アドバイス取得

### 月分析

- 年分析と同じ構造
- ライフサイクルマスタ（月）を使用
- 1ヶ月単位で計算

---

## 関連セル参照

| セル | 内容 |
|------|------|
| 分析1!A3 | 生年月日（文字列結合） |
| 分析1!B3 | 生年月日（シリアル値） |
| 分析1!G3 | 60類型番号 |
| 分析1!H3 | SP (1-10) |
| 分析1!E3 | 個性番号 (1-12) |
| 分析1!E5 | タイプコード（例: (A☆)） |
| ライフサイクルマスタ（年）!B2 | 起点年 |
| ライフサイクルマスタ（年）!B3 | SP |
| ライフサイクルマスタ（年）!B4-K4 | サイクル文字（10個） |
