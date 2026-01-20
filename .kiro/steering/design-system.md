# Design System

このファイルにプロジェクトのデザイントークンを定義してください。
`/ui-mockup` スキルはこのファイルを参照してモックアップを生成します。

---

## カラーパレット

### ダークテーマ
```
Background:       #0D1117
Background Card:  #161B22
Surface:          #1C2128
Border:           #30363D

Text Primary:     #F0F6FC
Text Secondary:   #8B949E
Text Muted:       #6E7681

Accent:           #10B981 (Emerald)
Accent Light:     #34D399
Success:          #10B981
Warning:          #F97316
Error:            #EF4444
```

### ライトテーマ
```
Background:       #FAFAFA
Background Card:  #F5F5F4
Surface:          #E7E5E4
Border:           #D6D3D1

Text Primary:     #1C1917
Text Secondary:   #57534E
Text Muted:       #78716C

Accent:           #059669 (Emerald Dark)
```

---

## タイポグラフィ

| Style | Size | Weight | Line Height |
|-------|------|--------|-------------|
| H1 | 32px | 700 | 40px |
| H2 | 24px | 600 | 32px |
| H3 | 18px | 600 | 24px |
| Body | 15px | 400 | 24px |
| Body Small | 13px | 400 | 20px |
| Caption | 12px | 500 | 16px |
| Label | 12px | 600 | 16px |
| Button | 16px | 600 | - |

---

## スペーシング

| Token | Value |
|-------|-------|
| xs | 4px |
| sm | 8px |
| md | 16px |
| lg | 24px |
| xl | 32px |
| 2xl | 48px |
| gutter | 20px |

---

## ボーダー半径

| Token | Value |
|-------|-------|
| sm | 8px |
| md | 12px |
| lg | 16px |
| xl | 20px |
| 2xl | 24px |
| full | 9999px |

---

## コンポーネントパターン

### カード
- Background: `backgroundCard`
- Border: 1px solid `border`
- Border Radius: `2xl` (24px)
- Padding: `lg` (24px)

### ボタン（Primary）
- Background: `accent`
- Text: `textInverse`
- Border Radius: `md` (12px)
- Padding: 12px 20px

### ボタン（Outline）
- Background: transparent
- Border: 1px solid `accent`
- Text: `accent`
- Border Radius: `md` (12px)

### 入力フィールド
- Background: `surface`
- Border: 1px solid `border`
- Border Radius: `xl` (20px)
- Padding: 12px 16px

### ボトムナビゲーション
- Background: `backgroundCard`
- Border Top: 1px solid `border`
- アイコンサイズ: 24px
- ラベル: 10px

---

## アニメーション

- Duration: 200-300ms
- Easing: ease-out
- FadeInDown for mount animations
- Respect `prefers-reduced-motion`
