---
name: gemini-mockup-review
description: Gemini 3 Flash を使用して理想UIモックアップとHTML実装を比較レビュー。プロンプト例、API呼び出し手順、Storybook統合方法を含む。
---

# Gemini 3 Flash モックアップ比較レビュー

## 概要

Gemini 3 Flash の画像理解能力を活用し、**理想UIモックアップ** と **HTML実装** を厳格に比較レビューするワークフロー。

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
2. HTML実装を作成
3. Storybookで並べて表示
4. Playwrightでスクリーンショット取得
5. Gemini 3 Flash で比較レビュー
6. フィードバックに基づき修正
7. 再レビューで効果測定
```

---

## 事前準備

### 1. 環境変数設定

```bash
export GEMINI_API_KEY="your-api-key"
```

### 2. Storybook比較ストーリー

```javascript
// storybook/comparison.stories.js
export default { title: 'Mockup/比較' };

const compare = (name, idealImg, htmlFile) => `
  <div style="display:flex;gap:48px;padding:24px;">
    <div>
      <div style="color:#7BC7A4;">✦ 理想UI</div>
      <img src="/${idealImg}" style="width:375px;"/>
    </div>
    <div>
      <div style="color:#E0B86B;">✦ HTML実装</div>
      <iframe src="/${htmlFile}" style="width:375px;height:812px;border:none;"></iframe>
    </div>
  </div>
`;

export const Welcome = () => compare('Welcome', 'ideal-welcome.png', 'welcome.html');
```

---

## スクリーンショット取得

### Playwright スクリプト

```javascript
// scripts/capture-html.js
const { chromium } = require('playwright');

async function capture(htmlFiles, outputDir) {
  const browser = await chromium.launch();
  const context = await browser.newContext({ viewport: { width: 375, height: 812 } });

  for (const file of htmlFiles) {
    const page = await context.newPage();
    await page.goto(`file://${process.cwd()}/mockup/${file}`);
    await page.waitForTimeout(500);
    const name = file.replace('.html', '.png');
    await page.screenshot({ path: `${outputDir}/${name}` });
    await page.close();
  }

  await browser.close();
}

capture(['welcome.html', 'dashboard.html'], './screenshots');
```

---

## Gemini API 呼び出し

### 比較レビュープロンプト

```
あなたは厳格なUI/UXエキスパートです。

## タスク
「理想UI」と「HTML実装」を比較し、再現度をパーセントで評価してください。

## 評価基準
1. グラスモーフィズム（backdrop-filter blur）の透け感
2. グロー効果（box-shadow, filter: drop-shadow）
3. グラデーションの深みと多色使い
4. タイポグラフィ（フォント、サイズ、ウェイト）
5. レイアウトと余白
6. 装飾要素の緻密さ

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
const { GoogleGenerativeAI } = require('@google/generative-ai');
const fs = require('fs');

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function reviewMockups(idealImages, htmlImages) {
  const model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' });

  const imageParts = [];

  // 理想UIを追加
  for (const img of idealImages) {
    const data = fs.readFileSync(img);
    imageParts.push({
      inlineData: { data: data.toString('base64'), mimeType: 'image/png' }
    });
  }

  // HTML実装スクリーンショットを追加
  for (const img of htmlImages) {
    const data = fs.readFileSync(img);
    imageParts.push({
      inlineData: { data: data.toString('base64'), mimeType: 'image/png' }
    });
  }

  const prompt = `
    最初の${idealImages.length}枚が「理想UI」、
    次の${htmlImages.length}枚が「HTML実装」です。
    同じ画面同士を比較し、再現度を評価してください。
  `;

  const result = await model.generateContent([prompt, ...imageParts]);
  return result.response.text();
}
```

---

## 典型的な指摘事項と修正

### 1. グラスモーフィズム不足

**指摘**: 「背景が透けるガラスのような質感がない」

**修正**:
```css
.card {
  background: rgba(25, 15, 50, 0.65);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}
```

### 2. グロー効果不足

**指摘**: 「枠自体の発光が再現されていない」

**修正**:
```css
.card {
  box-shadow:
    0 8px 32px rgba(0, 0, 0, 0.4),
    0 0 60px rgba(138, 107, 242, 0.12),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
}
```

### 3. 過剰な装飾

**指摘**: 「理想UIにない装飾が追加されている」

**修正**:
```css
.corner-ornaments { display: none !important; }
.footer-ornament { display: none; }
```

### 4. タイポグラフィ

**指摘**: 「フォントが細く、読みにくい」

**修正**:
```css
body {
  font-family: "Shippori Mincho", "Yu Mincho", serif;
  font-size: 15px;
  line-height: 1.7;
}
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
