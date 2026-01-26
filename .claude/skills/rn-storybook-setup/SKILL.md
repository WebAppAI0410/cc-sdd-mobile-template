---
description: This skill should be used when the user asks to "set up Storybook", "configure React Native Storybook", "create component stories", "add Storybook to Expo project", or works with component isolation, visual testing, or design system documentation.
---

# React Native Storybook Setup Skill

Expo プロジェクトに React Native Storybook をセットアップするガイド。
コンポーネントの独立開発・視覚的テスト・デザインシステムのドキュメント化を実現。

---

## 1. 前提条件

### 1.1 必須要件

| 要件 | 確認方法 | 備考 |
|------|---------|------|
| Expo プロジェクト初期化済み | `package.json` が存在 | `npx create-expo-app` で作成 |
| Node.js 18+ | `node --version` | LTS推奨 |
| TypeScript | `tsconfig.json` が存在 | 推奨 |

### 1.2 推奨要件

| 要件 | 目的 |
|------|------|
| デザインシステム定義 | `.kiro/steering/design-system.md` または `src/design/theme.ts` |
| コンポーネントディレクトリ | `src/components/` または `components/` |

---

## 2. インストール

### 2.1 自動セットアップ（推奨）

```bash
# Storybookの自動初期化
npx storybook@latest init
```

自動セットアップが完了すると以下が生成される:
- `.storybook/` ディレクトリ
- サンプルストーリー
- 必要な依存関係

### 2.2 手動セットアップ

自動セットアップが失敗した場合、または細かく制御したい場合:

```bash
# 依存関係のインストール
npm install --save-dev \
  @storybook/react-native \
  @storybook/addon-ondevice-controls \
  @storybook/addon-ondevice-actions \
  @storybook/addon-ondevice-notes \
  @storybook/addon-ondevice-backgrounds \
  @react-native-async-storage/async-storage

# ディレクトリ作成
mkdir -p .storybook
touch .storybook/main.ts .storybook/preview.tsx .storybook/index.tsx
```

---

## 3. 設定ファイル

### 3.1 .storybook/main.ts

Storybookのメイン設定ファイル。ストーリーの場所とアドオンを定義。

```typescript
// .storybook/main.ts
import type { StorybookConfig } from '@storybook/react-native';

const main: StorybookConfig = {
  stories: [
    '../src/components/**/*.stories.?(ts|tsx|js|jsx)',
    '../components/**/*.stories.?(ts|tsx|js|jsx)',
  ],
  addons: [
    '@storybook/addon-ondevice-controls',
    '@storybook/addon-ondevice-actions',
    '@storybook/addon-ondevice-notes',
    '@storybook/addon-ondevice-backgrounds',
  ],
};

export default main;
```

### 3.2 .storybook/preview.tsx

デコレーターとグローバルパラメータを設定。デザイントークンの適用もここで行う。

```typescript
// .storybook/preview.tsx
import type { Preview } from '@storybook/react';
import React from 'react';
import { View } from 'react-native';

// デザインシステムがある場合はインポート
// import { ThemeProvider } from '../src/design/ThemeProvider';
// import { theme } from '../src/design/theme';

const preview: Preview = {
  decorators: [
    (Story) => (
      <View style={{ flex: 1, padding: 16 }}>
        {/* ThemeProvider でラップする場合 */}
        {/* <ThemeProvider theme={theme}> */}
          <Story />
        {/* </ThemeProvider> */}
      </View>
    ),
  ],
  parameters: {
    // 背景色のプリセット（デザインシステムに合わせて調整）
    backgrounds: {
      default: 'dark',
      values: [
        { name: 'dark', value: '#0D1117' },
        { name: 'light', value: '#FAFAFA' },
        { name: 'card-dark', value: '#161B22' },
        { name: 'card-light', value: '#F5F5F4' },
      ],
    },
  },
};

export default preview;
```

### 3.3 .storybook/index.tsx

Storybook UIのエントリーポイント。

```typescript
// .storybook/index.tsx
import { view } from './storybook.requires';
import AsyncStorage from '@react-native-async-storage/async-storage';

const StorybookUIRoot = view.getStorybookUI({
  // オンデバイスUIを有効化
  onDeviceUI: true,

  // ストーリー選択の永続化
  shouldPersistSelection: true,

  // 初期表示するストーリー
  initialSelection: {
    kind: 'Components/Button',
    name: 'Primary',
  },

  // AsyncStorageで状態を保存
  storage: {
    getItem: AsyncStorage.getItem,
    setItem: AsyncStorage.setItem,
  },

  // WebSocket（リモートデバッグ用、オプション）
  enableWebsockets: false,
  host: 'localhost',
  port: 7007,
});

export default StorybookUIRoot;
```

### 3.4 metro.config.js

Metro バンドラーの設定を更新。

```javascript
// metro.config.js
const { getDefaultConfig } = require('expo/metro-config');
const withStorybook = require('@storybook/react-native/metro/withStorybook');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

module.exports = withStorybook(config);
```

**既存の metro.config.js がある場合**:

```javascript
// metro.config.js
const { getDefaultConfig } = require('expo/metro-config');
const withStorybook = require('@storybook/react-native/metro/withStorybook');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

// 既存の設定をマージ
config.resolver.sourceExts.push('mjs');

// Storybookラッパーを適用
module.exports = withStorybook(config);
```

---

## 4. package.json スクリプト

以下のスクリプトを `package.json` に追加:

```json
{
  "scripts": {
    "storybook": "EXPO_PUBLIC_STORYBOOK_ENABLED=true expo start",
    "storybook:ios": "EXPO_PUBLIC_STORYBOOK_ENABLED=true expo start --ios",
    "storybook:android": "EXPO_PUBLIC_STORYBOOK_ENABLED=true expo start --android",
    "storybook:generate": "sb-rn-get-stories"
  }
}
```

| スクリプト | 説明 |
|-----------|------|
| `storybook` | Storybook を起動（デフォルト） |
| `storybook:ios` | iOS シミュレータで Storybook 起動 |
| `storybook:android` | Android エミュレータで Storybook 起動 |
| `storybook:generate` | storybook.requires.ts を再生成 |

---

## 5. アプリエントリーポイントの変更

### 5.1 環境変数による条件分岐（推奨）

```typescript
// App.tsx または app/_layout.tsx
import { View, Text, StyleSheet } from 'react-native';

function App() {
  return (
    <View style={styles.container}>
      <Text>メインアプリ</Text>
    </View>
  );
}

// Storybook の条件付きロード
let AppEntryPoint = App;

if (process.env.EXPO_PUBLIC_STORYBOOK_ENABLED === 'true') {
  AppEntryPoint = require('./.storybook').default;
}

export default AppEntryPoint;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
```

### 5.2 Expo Router を使用している場合

#### app/storybook.tsx（専用ルート）

```typescript
// app/storybook.tsx
export { default } from '../.storybook';
```

#### app/_layout.tsx（開発時のみ表示）

```typescript
// app/_layout.tsx
import { Stack } from 'expo-router';

const isDevelopment = __DEV__ || process.env.NODE_ENV === 'development';

export default function RootLayout() {
  return (
    <Stack>
      <Stack.Screen name="index" />
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      {/* 開発時のみStorybookルートを有効化 */}
      {isDevelopment && (
        <Stack.Screen name="storybook" options={{ headerShown: false }} />
      )}
    </Stack>
  );
}
```

**ナビゲーション例**（開発メニューから）:

```typescript
import { router } from 'expo-router';

// Storybook画面へ遷移
const openStorybook = () => {
  router.push('/storybook');
};
```

---

## 6. ストーリーファイルの作成

### 6.1 基本構造（CSF形式）

```typescript
// src/components/Button/Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta = {
  title: 'Components/Button',
  component: Button,
  // 引数のコントロール設定
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'outline'],
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
    },
    disabled: {
      control: 'boolean',
    },
  },
} satisfies Meta<typeof Button>;

export default meta;

type Story = StoryObj<typeof meta>;

// Primary バリアント
export const Primary: Story = {
  args: {
    children: 'Primary Button',
    variant: 'primary',
    onPress: () => console.log('Primary pressed'),
  },
};

// Secondary バリアント
export const Secondary: Story = {
  args: {
    children: 'Secondary Button',
    variant: 'secondary',
    onPress: () => console.log('Secondary pressed'),
  },
};

// Outline バリアント
export const Outline: Story = {
  args: {
    children: 'Outline Button',
    variant: 'outline',
    onPress: () => console.log('Outline pressed'),
  },
};

// Disabled 状態
export const Disabled: Story = {
  args: {
    children: 'Disabled Button',
    variant: 'primary',
    disabled: true,
  },
};
```

### 6.2 サンプルコンポーネント

```typescript
// src/components/Button/Button.tsx
import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  ViewStyle,
  TextStyle,
} from 'react-native';

type ButtonVariant = 'primary' | 'secondary' | 'outline';
type ButtonSize = 'sm' | 'md' | 'lg';

interface ButtonProps {
  children: string;
  variant?: ButtonVariant;
  size?: ButtonSize;
  disabled?: boolean;
  onPress?: () => void;
}

export function Button({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  onPress,
}: ButtonProps) {
  return (
    <TouchableOpacity
      style={[
        styles.base,
        styles[variant],
        styles[`size_${size}`],
        disabled && styles.disabled,
      ]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={0.8}
    >
      <Text
        style={[
          styles.text,
          styles[`text_${variant}`],
          disabled && styles.textDisabled,
        ]}
      >
        {children}
      </Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  base: {
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  // Variants
  primary: {
    backgroundColor: '#10B981', // Accent from design-system.md
  },
  secondary: {
    backgroundColor: '#1C2128', // Surface
  },
  outline: {
    backgroundColor: 'transparent',
    borderWidth: 1,
    borderColor: '#10B981',
  },
  // Sizes
  size_sm: {
    paddingVertical: 8,
    paddingHorizontal: 12,
  },
  size_md: {
    paddingVertical: 12,
    paddingHorizontal: 20,
  },
  size_lg: {
    paddingVertical: 16,
    paddingHorizontal: 24,
  },
  // States
  disabled: {
    opacity: 0.5,
  },
  // Text
  text: {
    fontSize: 16,
    fontWeight: '600',
  },
  text_primary: {
    color: '#FFFFFF',
  },
  text_secondary: {
    color: '#F0F6FC', // Text Primary
  },
  text_outline: {
    color: '#10B981',
  },
  textDisabled: {
    color: '#6E7681', // Text Muted
  },
});
```

---

## 7. デザイントークン統合

### 7.1 テーマプロバイダーの作成

`.kiro/steering/design-system.md` のトークンを TypeScript で定義:

```typescript
// src/design/theme.ts
export const theme = {
  colors: {
    // Dark theme
    background: '#0D1117',
    backgroundCard: '#161B22',
    surface: '#1C2128',
    border: '#30363D',
    textPrimary: '#F0F6FC',
    textSecondary: '#8B949E',
    textMuted: '#6E7681',
    accent: '#10B981',
    accentLight: '#34D399',
    success: '#10B981',
    warning: '#F97316',
    error: '#EF4444',
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    '2xl': 48,
    gutter: 20,
  },
  borderRadius: {
    sm: 8,
    md: 12,
    lg: 16,
    xl: 20,
    '2xl': 24,
    full: 9999,
  },
  typography: {
    h1: { fontSize: 32, fontWeight: '700' as const, lineHeight: 40 },
    h2: { fontSize: 24, fontWeight: '600' as const, lineHeight: 32 },
    h3: { fontSize: 18, fontWeight: '600' as const, lineHeight: 24 },
    body: { fontSize: 15, fontWeight: '400' as const, lineHeight: 24 },
    bodySmall: { fontSize: 13, fontWeight: '400' as const, lineHeight: 20 },
    caption: { fontSize: 12, fontWeight: '500' as const, lineHeight: 16 },
    label: { fontSize: 12, fontWeight: '600' as const, lineHeight: 16 },
    button: { fontSize: 16, fontWeight: '600' as const },
  },
} as const;

export type Theme = typeof theme;
```

### 7.2 Storybook preview.tsx でテーマ適用

```typescript
// .storybook/preview.tsx
import type { Preview } from '@storybook/react';
import React from 'react';
import { View } from 'react-native';
import { theme } from '../src/design/theme';

const preview: Preview = {
  decorators: [
    (Story) => (
      <View
        style={{
          flex: 1,
          backgroundColor: theme.colors.background,
          padding: theme.spacing.md,
        }}
      >
        <Story />
      </View>
    ),
  ],
  parameters: {
    backgrounds: {
      default: 'dark',
      values: [
        { name: 'dark', value: theme.colors.background },
        { name: 'light', value: '#FAFAFA' },
        { name: 'card', value: theme.colors.backgroundCard },
        { name: 'surface', value: theme.colors.surface },
      ],
    },
  },
};

export default preview;
```

---

## 8. ディレクトリ構造

セットアップ完了後の構造:

```
.storybook/
├── main.ts              # メイン設定
├── preview.tsx          # デコレーター・グローバルパラメータ
├── index.tsx            # Storybook UI エントリー
└── storybook.requires.ts # 自動生成（コミット対象外）

src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.stories.tsx
│   │   └── index.ts
│   └── Card/
│       ├── Card.tsx
│       ├── Card.stories.tsx
│       └── index.ts
└── design/
    └── theme.ts         # デザイントークン

metro.config.js          # Metro設定（Storybook対応）
```

---

## 9. 実行方法

### 9.1 Storybook の起動

```bash
# 開発サーバー起動（Storybook モード）
npm run storybook

# iOS シミュレータで起動
npm run storybook:ios

# Android エミュレータで起動
npm run storybook:android
```

### 9.2 ストーリーの再生成

新しいストーリーファイルを追加した後:

```bash
npm run storybook:generate
```

---

## 10. トラブルシューティング

| 問題 | 解決方法 |
|------|---------|
| ストーリーが表示されない | `npm run storybook:generate` で再生成 |
| Metro エラー | `npx expo start -c` でキャッシュクリア |
| TypeScript エラー | `@storybook/react` の型をインポートしているか確認 |
| AsyncStorage エラー | `@react-native-async-storage/async-storage` をインストール |
| 背景が白いまま | `preview.tsx` のデコレーターで背景色を設定 |

---

## 11. cc-sdd ワークフローとの統合

### 11.1 推奨フロー

```
/kiro:spec-design → /ui-mockup → Storybook ストーリー作成 → /impl-loop
```

1. **spec-design**: コンポーネント設計を定義
2. **ui-mockup**: HTML モックアップで視覚的確認
3. **Storybook**: コンポーネントのバリエーションをストーリー化
4. **impl-loop**: TDD で実装

### 11.2 品質チェックとの連携

```bash
# 型チェック（ストーリーファイル含む）
npx tsc --noEmit

# 全検証
/verify
```

---

## 12. クイックリファレンス

```bash
# セットアップ
npx storybook@latest init

# 起動
npm run storybook

# ストーリー再生成
npm run storybook:generate

# キャッシュクリア＆起動
npx expo start -c
```
