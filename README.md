# cc-sdd Mobile Template

Claude Code Spec-Driven Development (cc-sdd) テンプレートリポジトリ。

React Native + Expo モバイルアプリ開発用。

## 使用方法

### 新規プロジェクト作成

```bash
# GitHub CLI でテンプレートからリポジトリ作成
gh repo create my-new-app --template hdyk/cc-sdd-mobile-template --private
cd my-new-app

# または既存ディレクトリにコピー
git clone https://github.com/hdyk/cc-sdd-mobile-template .cc-sdd-temp
cp -r .cc-sdd-temp/.kiro .
cp -r .cc-sdd-temp/.claude .
cp .cc-sdd-temp/CLAUDE.md .
rm -rf .cc-sdd-temp
```

### セットアップ後

1. `CLAUDE.md` をプロジェクト固有の内容に更新
2. `.kiro/steering/design-system.md` にデザイントークンを定義
3. Expoプロジェクトを初期化:
   ```bash
   npx create-expo-app@latest . --template expo-template-blank-typescript
   ```
   - 既に `package.json` が存在するため、必要に応じて上書き or サブディレクトリ作成で回避

## 含まれるもの

### SDD (Spec-Driven Development)

| コマンド | 説明 |
|----------|------|
| `/kiro:spec-init` | 仕様書初期化 |
| `/kiro:spec-requirements` | 要件生成 |
| `/kiro:spec-design` | 技術設計 |
| `/kiro:spec-tasks` | タスク生成 |
| `/kiro:spec-impl` | TDD実装 |

### Skills

| Skill | 説明 |
|-------|------|
| `/ui-mockup` | React Native Storybookコンポーネント生成 |
| `/quality-check` | TypeScript・テスト品質チェック |
| `/impl-loop` | 実装→レビュー→修正ループ |
| `rn-storybook-setup` | React Native Storybookセットアップガイド |
| `gemini-mockup-review` | Gemini 3 Flashで理想UIとRN実装を比較レビュー |

### Agents

- `rn-expert`: React Native / Expo / TypeScript 実装エージェント

### Rules

- `react-native.md`: React Native コーディング規約
- `typescript.md`: TypeScript 規約

## ワークフロー

```
[Requirements] → [Design] → [RN Storybook] → [Tasks] → [Implementation]
     ↓              ↓             ↓              ↓            ↓
  /spec-req     /spec-design   /ui-mockup   /spec-tasks  /impl-loop
                                   ↓
                        [Gemini比較レビュー]
```

### UIモックアップ → 本番実装の流れ

1. `/ui-mockup` で React Native コンポーネント + Storybook ストーリーを生成
2. Storybook でデバイス上にプレビュー
3. Gemini 3 Flash で理想UIと比較レビュー
4. `/impl-loop` で本番実装（Storybookコンポーネントを活用）

## ライセンス

MIT
