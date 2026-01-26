# UI Mockup Skill

## Description

仕様書段階でReact Nativeコンポーネントをstorybook形式で生成し、実機/シミュレーターでプレビューするスキル。
実際のアプリと同じコンポーネントでUI検証が可能。

## Triggers

This skill should be used when the user asks to:
- "モックアップを作成"
- "UIプレビューを見せて"
- "画面デザインを確認したい"
- "仕様書のUIを視覚化"
- "コンポーネントのStorybookを作成"
- "/ui-mockup"

## Prerequisites

1. **Storybookセットアップ** (初回のみ):
   - `@storybook/react-native` がインストールされている
   - `.storybook/` 設定が存在する
   - package.jsonに `"storybook": "storybook-dev-server"` スクリプトがある

2. **デザインシステム定義** (いずれか):
   - `src/design/theme.ts` が存在する
   - `.kiro/steering/design-system.md` が存在する
   - ユーザーがカラー/フォント情報を提供する

3. **画面仕様** (いずれか):
   - `.kiro/specs/{feature}/requirements.md` に画面要件がある
   - ユーザーが画面要件を口頭で説明する

## Storybook Setup (初回のみ)

Storybookがセットアップされていない場合:

```bash
# Storybook React Native をインストール
npx sb@latest init --type react_native

# 追加の依存関係
npm install @storybook/addon-ondevice-controls @storybook/addon-ondevice-actions

# package.json にスクリプト追加
# "storybook": "STORYBOOK_ENABLED=true expo start"
```

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

### Step 3: React Nativeコンポーネント生成

```
1. src/components/mockup/ ディレクトリを作成（なければ）
2. 各画面のコンポーネントファイルを生成:
   - {ScreenName}Mockup.tsx
   - theme.ts からのデザイントークンを使用
   - StyleSheet.create でスタイル定義
```

### Step 4: Storybookストーリー生成

```
1. 対応する .stories.tsx ファイルを生成:
   - {ScreenName}Mockup.stories.tsx
   - 複数のバリエーション（light/dark、状態違い）
   - args でプロパティを調整可能に
```

### Step 5: Storybookでプレビュー

```bash
# Storybookモードで起動
npm run storybook

# または Expo で直接起動
STORYBOOK_ENABLED=true npx expo start
```

### Step 6: スクリーンショット取得

```
1. シミュレーター/実機でStorybookを開く
2. 対象のストーリーを選択
3. Maestro または Chrome MCP でスクリーンショット取得
```

## React Native Component Template

```tsx
// src/components/mockup/{ScreenName}Mockup.tsx
import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { theme } from '@/design/theme';

interface {ScreenName}MockupProps {
  // Props definition
}

export const {ScreenName}Mockup: React.FC<{ScreenName}MockupProps> = (props) => {
  return (
    <ScrollView style={styles.container}>
      {/* Screen content */}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  // Component styles using theme tokens
  text: {
    color: theme.colors.textPrimary,
    fontSize: theme.typography.body.fontSize,
  },
  card: {
    backgroundColor: theme.colors.backgroundCard,
    borderRadius: theme.borderRadius.md,
    padding: theme.spacing.md,
    marginVertical: theme.spacing.sm,
  },
});
```

## Storybook Story Template

```tsx
// src/components/mockup/{ScreenName}Mockup.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { {ScreenName}Mockup } from './{ScreenName}Mockup';

const meta: Meta<typeof {ScreenName}Mockup> = {
  title: 'Mockups/{ScreenName}',
  component: {ScreenName}Mockup,
  parameters: {
    layout: 'fullscreen',
  },
  argTypes: {
    // Props controls
  },
};

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    // Default props
  },
};

export const DarkMode: Story = {
  args: {
    // Dark mode props
  },
  parameters: {
    backgrounds: { default: 'dark' },
  },
};

export const WithData: Story = {
  args: {
    // Props with sample data
  },
};
```

## Common Components

### Card

```tsx
<View style={styles.card}>
  <Text style={styles.cardIcon}>{emoji}</Text>
  <View style={styles.cardContent}>
    <Text style={styles.cardTitle}>{title}</Text>
    <Text style={styles.cardDescription}>{description}</Text>
  </View>
</View>
```

### Button

```tsx
import { Pressable, Text, StyleSheet } from 'react-native';

<Pressable style={styles.btnPrimary}>
  <Text style={styles.btnPrimaryText}>{label}</Text>
</Pressable>

<Pressable style={styles.btnOutline}>
  <Text style={styles.btnOutlineText}>{label}</Text>
</Pressable>
```

### Bottom Navigation

```tsx
<View style={styles.bottomNav}>
  <Pressable style={[styles.navItem, styles.navItemActive]}>
    <IconComponent name="home" />
    <Text style={styles.navLabel}>{label}</Text>
  </Pressable>
  {/* More items */}
</View>
```

### Progress Bar

```tsx
<View style={styles.progressBar}>
  <View style={[styles.progressFill, { width: `${percent}%` }]} />
</View>
```

## Screenshot Capture Methods

### Method 1: Maestro (推奨)

```yaml
# .maestro/screenshot-mockup.yaml
appId: com.yourapp.dev
---
- launchApp
- tapOn: "Mockups"
- tapOn: "{ScreenName}"
- takeScreenshot: mockup-{screen-name}
```

```bash
maestro test .maestro/screenshot-mockup.yaml
```

### Method 2: Chrome MCP (Web Storybook)

Storybook Webビルドを使用する場合:

```bash
# Web版Storybookをビルド・起動
npm run storybook:web
```

```
1. Chrome MCP で tabs_context_mcp を確認
2. http://localhost:6006 にナビゲート
3. 対象ストーリーを選択
4. スクリーンショットを取得
```

### Method 3: iOS Simulator Screenshot

```bash
xcrun simctl io booted screenshot mockup-screenshot.png
```

## Output

モックアップ生成後、以下を報告:

1. 生成したコンポーネントファイル一覧
2. 生成したStorybookストーリー一覧
3. Storybook起動コマンド
4. スクリーンショット（取得した場合）
5. 変更リクエストの受付

## Example Usage

```
User: "ダッシュボード画面のモックアップを作成して"

Claude:
1. theme.ts からデザイントークンを読み込み
2. 仕様書から画面要件を確認
3. src/components/mockup/DashboardMockup.tsx を生成
4. src/components/mockup/DashboardMockup.stories.tsx を生成
5. Storybookでプレビュー起動
6. スクリーンショット取得・表示
```

## Tips

- コンポーネントは実際の実装に再利用可能な形で作成
- Storybookのaddon-controlsでプロパティを動的に変更可能
- 複数のバリエーション（状態、テーマ）をストーリーで網羅
- デザイントークンは必ず theme.ts から参照（ハードコード禁止）
