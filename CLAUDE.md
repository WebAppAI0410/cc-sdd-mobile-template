# CLAUDE.md - cc-sdd Mobile Template

## 言語設定
- **日本語で応答してください**
- コード内のコメントは英語でも可

---

## プロジェクト概要

このプロジェクトはcc-sdd (Claude Code Spec-Driven Development) テンプレートから作成されました。

**技術スタック**: React Native + Expo + TypeScript

## セットアップ後のTODO

1. このファイルをプロジェクト固有の内容に更新
2. `.kiro/steering/design-system.md` にデザイントークンを定義
3. `package.json` を作成（`npx create-expo-app` 等）

---

## 仕様駆動開発 (SDD)

### ワークフロー
```
/kiro:spec-init → /kiro:spec-requirements → /kiro:spec-design → /kiro:spec-tasks → /kiro:spec-impl
```

### 利用可能なコマンド

| コマンド | 説明 |
|----------|------|
| `/kiro:spec-init` | 新しい仕様書を初期化 |
| `/kiro:spec-requirements` | 要件を生成 |
| `/kiro:spec-design` | 技術設計を作成 |
| `/kiro:spec-tasks` | 実装タスクを生成 |
| `/kiro:spec-impl` | TDDで実装を実行 |
| `/kiro:spec-status` | 仕様書の状態を確認 |

### UIモックアップ

| コマンド | 説明 |
|----------|------|
| `/ui-mockup` | HTMLモックアップを生成してプレビュー |

Design Phase後、Implementation前にモックアップで視覚的確認を推奨。

### E2Eテスト (Maestro)

| コマンド | 説明 |
|----------|------|
| `maestro test .maestro/` | 全E2Eテスト実行 |
| `maestro studio` | インタラクティブUI起動 |
| `maestro hierarchy` | 要素階層を確認 |

`.maestro/flows/` にフローファイルを配置。

---

## 品質基準

### Warning/Error 0 ポリシー
```bash
npx tsc --noEmit  # エラー 0 必須
npm test -- --passWithNoTests  # テスト全パス
```

### 禁止事項

| 禁止 | 代替 |
|------|------|
| `// @ts-ignore` | 適切な型定義 |
| `any` 型 | `unknown` + narrowing |
| ハードコード日本語 | `t('key')` を使用 |
| `console.log` 残存 | 削除 or `__DEV__` ガード |

---

## ディレクトリ構造

```
.kiro/
  specs/              # 機能別仕様書
  settings/           # SDDルール・テンプレート
  steering/           # プロジェクト知識（デザインシステム等）

.claude/
  skills/             # 利用可能なスキル
    ui-mockup/        # UIモックアップ生成
    sdd-workflow/     # SDDワークフロー
    quality-check/    # 品質チェック
    maestro-e2e/      # Maestro E2Eテスト
  commands/kiro/      # SDDコマンド
  agents/             # 専門エージェント
  rules/              # コーディングルール

mockup/               # HTMLモックアップ出力先

app/                  # Expo Router画面（作成後）
src/                  # ソースコード（作成後）
```

---

## Context7 MCP活用（必須）

外部ライブラリ・ツールの使い方を調べる際は、推測せずcontext7 MCPで公式ドキュメントを確認すること。

```
1. mcp__context7__resolve-library-id でライブラリIDを取得
2. mcp__context7__query-docs で具体的な使い方を検索
3. 公式ドキュメントに基づいて回答
```
