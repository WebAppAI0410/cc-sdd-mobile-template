---
name: gemini-mockup-review
description: Gemini 3 Flash を使用して理想UIモックアップとReact Native実装を比較レビュー。Storybook + Maestro/Simulator統合方法を含む。
---

# Gemini 3 Flash モックアップ比較レビュー

## 概要

Gemini 3 Flash の画像理解能力を活用し、**理想UIモックアップ** と **React Native実装** を厳格に比較レビューするワークフロー。

### なぜ効果的か

| 観点 | Claude単独 | Gemini比較レビュー |
|------|-----------|-------------------|
| 構造的評価 | ✅ 得意 | ✅ 得意 |
| 視覚的品質評価 | △ 限定的 | ✅ マルチモーダル |
| グロー/光沢の評価 | ❌ 困難 | ✅ 画像で直接比較 |
| 定量的スコア | △ 主観的 | ✅ 客観的パーセント |

---

## ワークフロー

```
1. 理想UIモックアップを生成（Gemini Image Generation）
2. React Native コンポーネントを実装
3. Storybook ストーリーを作成
4. iOS Simulator で Storybook を起動
5. Maestro または xcrun simctl でスクリーンショット取得
6. Gemini 3 Flash で比較レビュー
7. フィードバックに基づき修正
8. 再レビューで効果測定
```

---

## 事前準備

### 1. 環境変数設定

```bash
export GEMINI_API_KEY="your-api-key"
```

### 2. React Native Storybook セットアップ

```bash
# Storybook for React Native をインストール
npx storybook@latest init --type react_native

# 必要な依存関係
npm install @storybook/react-native @storybook/addon-ondevice-controls @storybook/addon-ondevice-actions
```

### 3. Storybook 設定

```javascript
// .storybook/main.js
module.exports = {
  stories: ['../components/**/*.stories.?(ts|tsx|js|jsx)'],
  addons: [
    '@storybook/addon-ondevice-controls',
    '@storybook/addon-ondevice-actions',
  ],
};
```

---

## React Native コンポーネント & ストーリー

### コンポーネント例

```tsx
// components/WelcomeCard.tsx
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { BlurView } from 'expo-blur';
import { LinearGradient } from 'expo-linear-gradient';

interface WelcomeCardProps {
  title: string;
  subtitle: string;
}

export const WelcomeCard: React.FC<WelcomeCardProps> = ({ title, subtitle }) => {
  return (
    <LinearGradient
      colors={['#1a0a2e', '#16082a']}
      style={styles.container}
    >
      <BlurView intensity={20} style={styles.card}>
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.subtitle}>{subtitle}</Text>
      </BlurView>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  card: {
    padding: 32,
    borderRadius: 24,
    backgroundColor: 'rgba(25, 15, 50, 0.65)',
    shadowColor: '#8a6bf2',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.3,
    shadowRadius: 32,
  },
  title: {
    fontSize: 28,
    fontWeight: '600',
    color: '#ffffff',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.7)',
  },
});
```

### Storybook ストーリー

```tsx
// components/WelcomeCard.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { WelcomeCard } from './WelcomeCard';

const meta: Meta<typeof WelcomeCard> = {
  title: 'Mockup/WelcomeCard',
  component: WelcomeCard,
  parameters: {
    // フルスクリーンでレンダリング（比較用）
    layout: 'fullscreen',
  },
};

export default meta;
type Story = StoryObj<typeof WelcomeCard>;

export const Default: Story = {
  args: {
    title: 'ようこそ',
    subtitle: '新しい体験を始めましょう',
  },
};

export const ForComparison: Story = {
  name: '比較用（理想UIと同サイズ）',
  args: {
    title: 'ようこそ',
    subtitle: '新しい体験を始めましょう',
  },
  parameters: {
    viewport: {
      defaultViewport: 'iphone14',
    },
  },
};
```

---

## スクリーンショット取得

### 方法 1: Maestro（推奨）

```yaml
# maestro/capture-storybook.yaml
appId: host.exp.Exponent  # Expo Go の場合
---
- launchApp
- waitForAnimationToEnd
# Storybookの特定ストーリーに移動
- tapOn: "Mockup"
- tapOn: "WelcomeCard"
- tapOn: "比較用"
- waitForAnimationToEnd
- takeScreenshot: screenshots/welcome-impl.png
```

```bash
# 実行
maestro test maestro/capture-storybook.yaml
```

### 方法 2: xcrun simctl（シンプル）

```bash
# iOS Simulator でスクリーンショット取得
xcrun simctl io booted screenshot screenshots/welcome-impl.png

# 特定デバイスを指定
xcrun simctl io "iPhone 15 Pro" screenshot screenshots/welcome-impl.png
```

### 方法 3: Node.js スクリプト

```javascript
// scripts/capture-rn-screenshot.js
const { execFileSync } = require('child_process');
const path = require('path');

function captureSimulatorScreenshot(outputPath) {
  const fullPath = path.resolve(outputPath);

  try {
    // Booted シミュレータのスクリーンショットを取得
    execFileSync('xcrun', ['simctl', 'io', 'booted', 'screenshot', fullPath], {
      stdio: 'inherit',
    });
    console.log(`Screenshot saved: ${fullPath}`);
    return fullPath;
  } catch (error) {
    console.error('Failed to capture screenshot:', error.message);
    throw error;
  }
}

function captureWithMaestro(flowFile, outputDir) {
  try {
    execFileSync('maestro', ['test', flowFile], {
      stdio: 'inherit',
      cwd: process.cwd(),
    });
    console.log(`Maestro flow completed. Screenshots in: ${outputDir}`);
  } catch (error) {
    console.error('Maestro capture failed:', error.message);
    throw error;
  }
}

module.exports = { captureSimulatorScreenshot, captureWithMaestro };
```

---

## Gemini API 呼び出し

### 比較レビュープロンプト

```
あなたは厳格なモバイルUI/UXエキスパートです。

## タスク
「理想UI」と「React Native実装」を比較し、再現度をパーセントで評価してください。

## 評価基準
1. グラスモーフィズム（BlurView）の透け感
2. グロー効果（shadowColor, shadowOpacity）
3. グラデーションの深みと多色使い（LinearGradient）
4. タイポグラフィ（フォント、サイズ、ウェイト）
5. レイアウトと余白（padding, margin）
6. 装飾要素の緻密さ
7. iOS/Android ネイティブ感

## 出力形式
| 画面 | 再現度 | 主な問題点 |
|------|--------|-----------|
| Welcome | XX% | ... |

## 厳格に評価すること
- 70%以上: 商用レベル
- 50-70%: 改善必要
- 50%未満: 大幅な修正必要
```

### Node.js 呼び出し例

```javascript
// scripts/gemini-review.js
const { GoogleGenerativeAI } = require('@google/generative-ai');
const fs = require('fs');
const path = require('path');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function reviewMockups(idealImages, rnImages) {
  const model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });

  const imageParts = [];

  // 理想UIを追加
  for (const img of idealImages) {
    const data = fs.readFileSync(img);
    imageParts.push({
      inlineData: { data: data.toString('base64'), mimeType: 'image/png' }
    });
  }

  // React Native実装スクリーンショットを追加
  for (const img of rnImages) {
    const data = fs.readFileSync(img);
    imageParts.push({
      inlineData: { data: data.toString('base64'), mimeType: 'image/png' }
    });
  }

  const prompt = `
    最初の${idealImages.length}枚が「理想UI」、
    次の${rnImages.length}枚が「React Native実装」です。
    同じ画面同士を比較し、再現度を評価してください。

    特に以下の点に注意:
    - BlurViewの透過効果
    - shadowプロパティによるグロー
    - LinearGradientの再現度
    - ネイティブらしい質感
  `;

  const result = await model.generateContent([prompt, ...imageParts]);
  return result.response.text();
}

// 使用例
async function main() {
  const idealImages = [
    'mockup/ideal-welcome.png',
    'mockup/ideal-dashboard.png',
  ];

  const rnImages = [
    'screenshots/welcome-impl.png',
    'screenshots/dashboard-impl.png',
  ];

  const review = await reviewMockups(idealImages, rnImages);
  console.log(review);

  // レビュー結果を保存
  fs.writeFileSync('GEMINI_COMPARISON_REVIEW.md', review);
}

main().catch(console.error);
```

---

## 典型的な指摘事項と修正

### 1. グラスモーフィズム不足

**指摘**: 「背景が透けるガラスのような質感がない」

**修正**:
```tsx
import { BlurView } from 'expo-blur';

<BlurView
  intensity={40}  // 強度を上げる
  tint="dark"
  style={styles.card}
>
  {/* content */}
</BlurView>
```

### 2. グロー効果不足

**指摘**: 「枠自体の発光が再現されていない」

**修正**:
```tsx
const styles = StyleSheet.create({
  card: {
    // iOS shadow
    shadowColor: '#8a6bf2',
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.4,
    shadowRadius: 32,
    // Android elevation (approximation)
    elevation: 12,
    // 内側の光沢感
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.1)',
  },
});
```

### 3. グラデーション不足

**指摘**: 「グラデーションの深みが足りない」

**修正**:
```tsx
import { LinearGradient } from 'expo-linear-gradient';

<LinearGradient
  colors={['#1a0a2e', '#0d0518', '#16082a']}
  locations={[0, 0.5, 1]}
  start={{ x: 0, y: 0 }}
  end={{ x: 1, y: 1 }}
  style={styles.background}
>
```

### 4. タイポグラフィ

**指摘**: 「フォントが細く、読みにくい」

**修正**:
```tsx
import { useFonts, ShipporiMincho_400Regular } from '@expo-google-fonts/shippori-mincho';

const styles = StyleSheet.create({
  text: {
    fontFamily: 'ShipporiMincho_400Regular',
    fontSize: 15,
    lineHeight: 25,  // fontSize * 1.7
    letterSpacing: 0.5,
  },
});
```

---

## 再レビューサイクル

```
修正前: 34% → 修正後: 75-85%（目標）
```

### 効果測定
1. 同じプロンプトで再レビュー
2. パーセント変化を記録
3. 残りの指摘事項を特定
4. 必要に応じて追加修正

---

## 完全なワークフロー例

```bash
# 1. 理想UIモックアップ生成（別スキルで実行）
# → mockup/ideal-welcome.png

# 2. React Native コンポーネント実装
# → components/WelcomeCard.tsx
# → components/WelcomeCard.stories.tsx

# 3. Storybook起動（iOS Simulator）
npm run storybook:ios

# 4. スクリーンショット取得
xcrun simctl io booted screenshot screenshots/welcome-impl.png

# 5. Gemini比較レビュー実行
node scripts/gemini-review.js

# 6. レビュー結果確認
cat GEMINI_COMPARISON_REVIEW.md

# 7. 修正 → 再レビューのサイクル
```

---

## 成果物

レビュー結果は以下のMarkdownファイルに記録：

- `GEMINI_REVIEW.md` - 単独レビュー（理想UIのみ）
- `GEMINI_COMPARISON_REVIEW.md` - 比較レビュー
- `GEMINI_FIXES_APPLIED.md` - 修正レポート

---

## Tips

1. **Temperature低め (0.1)**: 厳格で一貫した評価のため
2. **画像は8枚まで**: 4画面 × 2（理想+実装）が最適
3. **定量的評価を要求**: パーセントで出力させる
4. **複数回レビュー**: 修正→再レビューのサイクルを回す
5. **iOS Simulatorを使用**: 実機に近い描画結果を得るため
6. **Maestroで自動化**: 複数画面のキャプチャを効率化
7. **Storybook isolated render**: 余計なUI要素なしで純粋なコンポーネントをキャプチャ
