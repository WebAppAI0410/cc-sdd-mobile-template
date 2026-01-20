# UI Mockup Skill

## Description

仕様書段階でHTMLモックアップを生成し、ブラウザでプレビューするスキル。
ビルド不要で即座にUI検証が可能。

## Triggers

This skill should be used when the user asks to:
- "モックアップを作成"
- "UIプレビューを見せて"
- "画面デザインを確認したい"
- "仕様書のUIを視覚化"
- "/ui-mockup"

## Prerequisites

1. **デザインシステム定義** (いずれか):
   - `src/design/theme.ts` が存在する
   - `.kiro/steering/design-system.md` が存在する
   - ユーザーがカラー/フォント情報を提供する

2. **画面仕様** (いずれか):
   - `.kiro/specs/{feature}/requirements.md` に画面要件がある
   - ユーザーが画面要件を口頭で説明する

## Workflow

### Step 1: デザイントークンの収集

```
1. src/design/theme.ts を読み込み（存在する場合）
2. .kiro/steering/design-system.md を読み込み（存在する場合）
3. カラーパレット、タイポグラフィ、スペーシングを抽出
```

### Step 2: 画面要件の確認

```
1. 対象の仕様書を読み込み
2. 画面構成要素をリストアップ:
   - ヘッダー
   - メインコンテンツ
   - ナビゲーション
   - ボタン/インタラクション
```

### Step 3: HTMLモックアップ生成

```
1. mockup/ ディレクトリを作成（なければ）
2. 各画面のHTMLファイルを生成:
   - インラインCSS（外部依存なし）
   - モバイルビューポート (max-width: 390px)
   - ダーク/ライトテーマ対応
```

### Step 4: ローカルサーバー起動

```bash
cd mockup && python3 -m http.server 8888
```

### Step 5: ブラウザプレビュー

```
1. Chrome MCP で tabs_context_mcp を確認
2. http://localhost:8888/{screen}.html にナビゲート
3. スクリーンショットを取得してユーザーに表示
```

## HTML Template Structure

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=390, initial-scale=1.0">
    <title>{Screen Name} - Mockup</title>
    <style>
        :root {
            /* Design tokens from theme.ts or steering */
            --background: {colors.background};
            --background-card: {colors.backgroundCard};
            --text-primary: {colors.textPrimary};
            --text-secondary: {colors.textSecondary};
            --accent: {colors.accent};
            --border: {colors.border};
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--background);
            color: var(--text-primary);
            max-width: 390px;
            margin: 0 auto;
            min-height: 100vh;
        }

        /* Component styles... */
    </style>
</head>
<body>
    <!-- Screen content -->
</body>
</html>
```

## Common Components

### Card
```html
<div class="card">
    <div class="card-icon">{emoji}</div>
    <div class="card-content">
        <h3>{title}</h3>
        <p>{description}</p>
    </div>
</div>
```

### Button
```html
<button class="btn btn-primary">{label}</button>
<button class="btn btn-outline">{label}</button>
```

### Bottom Navigation
```html
<nav class="bottom-nav">
    <div class="nav-item active">
        <svg>...</svg>
        <span>{label}</span>
    </div>
    <!-- More items -->
</nav>
```

### Progress Bar
```html
<div class="progress-bar">
    <div class="progress-fill" style="width: {percent}%"></div>
</div>
```

## Output

モックアップ生成後、以下を報告:

1. 生成したファイル一覧
2. プレビューURL
3. スクリーンショット（Chrome MCP経由）
4. 変更リクエストの受付

## Example Usage

```
User: "ダッシュボード画面のモックアップを作成して"