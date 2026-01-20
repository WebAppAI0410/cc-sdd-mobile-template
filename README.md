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
| `/ui-mockup` | HTMLモックアップ生成・プレビュー |
| `/quality-check` | TypeScript・テスト品質チェック |
| `/impl-loop` | 実装→レビュー→修正ループ |

### Agents

- `rn-expert`: React Native / Expo / TypeScript 実装エージェント

### Rules

- `react-native.md`: React Native コーディング規約
- `typescript.md`: TypeScript 規約

## ワークフロー

```
[Requirements] → [Design] → [UI Mockup] → [Tasks] → [Implementation]
     ↓              ↓            ↓            ↓            ↓
  /spec-req     /spec-design  /ui-mockup  /spec-tasks  /spec-impl
```

## ライセンス

MIT
