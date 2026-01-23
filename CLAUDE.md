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
2. `.kiro/steering/` にプロジェクト知識を定義
3. `package.json` を作成（`npx create-expo-app` 等）

---

## ⚠️ ワークフロー遵守ルール（重要）

### 全ステップ必須

**SDDワークフローの全フェーズを必ず実行すること。ステップをスキップしてはならない。**

| フェーズ | 必須 | スキップ禁止の理由 |
|---------|------|-------------------|
| spec-init | ✅ | 仕様書なしに実装開始禁止 |
| spec-requirements | ✅ | 要件不明確なまま設計禁止 |
| spec-design | ✅ | 設計なしに実装禁止 |
| spec-tasks | ✅ | タスク分解なしに実装禁止 |
| impl-loop | ✅ | TDD + レビューを必ず通す |
| verify | ✅ | 検証なしにコミット禁止 |

**例外**: バグ修正、タイポ修正、ドキュメント更新など「シンプルな場合」のみスキップ可。

### 承認フロー

各フェーズでユーザー承認を取得してから次へ進む：

```
requirements → [ユーザー承認] → design → [ユーザー承認] → tasks → [ユーザー承認] → impl
```

`-y` フラグは意図的なファストトラック時のみ使用。

### AI行動制限

**以下の行動は明示的な指示なしに禁止**:

| 禁止行動 | 説明 |
|----------|------|
| モック実装の作成 | 仕様書にない機能のモック・スタブ実装は禁止 |
| 未実装の宣言 | できていないことを「完了」と報告禁止 |
| 仕様外の機能追加 | `.kiro/specs/`の仕様書にない機能の追加禁止 |
| フェーズのスキップ | 「時間短縮のため」等の理由でのスキップ禁止 |
| プレースホルダー導入 | `// TODO`だけ残して中身がない実装の禁止 |

**許可される行動**:
- 仕様書に記載された機能の実装
- バグ修正
- リファクタリング（動作変更なし）
- 明示的に指示されたモック/スタブ実装

---

## 開発ワークフロー（Boris Cherny流）

> "give Claude a way to verify its work. If Claude has that feedback loop, it will 2-3x the quality of the final result." - Boris Cherny

### シンプルな場合（バグ修正、単純な変更）

```
実装 → /verify → (/simplify) → コミット
```

### 複雑な場合（新機能、アーキテクチャ変更）

```
┌────────────────────────────────────────────────────────────┐
│  1. Plan Mode (Shift+Tab × 2)                              │
│     └─ 計画を反復・ブラッシュアップ                         │
│                                                            │
│  2. 仕様駆動開発 (SDD)                                      │
│     /kiro:spec-init → requirements → design → tasks        │
│                                                            │
│  3. 実装ループ                                              │
│     /impl-loop <feature> [tasks]                           │
│     ├─ TDD実装 (RED → GREEN → REFACTOR)                    │
│     ├─ 品質チェック (tsc, test)                             │
│     ├─ レビュー (code-reviewer)                            │
│     └─ 検証 (/kiro:validate-impl)                          │
│                                                            │
│  4. 検証・簡潔化                                            │
│     /verify → /simplify                                    │
│                                                            │
│  5. コミット・PR                                            │
│     /commit-push-pr                                        │
└────────────────────────────────────────────────────────────┘
```

### いつ Plan Mode を使うか

| 使う | スキップ |
|------|---------|
| 新機能実装 | バグ修正（単純） |
| 複数ファイル変更 | タイポ修正 |
| アーキテクチャ変更 | ドキュメント更新 |
| 不明確な要件 | 明確な1行変更 |

---

## コマンド選択ガイド

### 仕様駆動開発（SDD）

| コマンド | 用途 | いつ使う |
|---------|------|---------|
| `/kiro:spec-init` | 仕様書初期化 | 新機能開始時 |
| `/kiro:spec-requirements` | 要件定義 | 何を作るか明確化 |
| `/kiro:spec-design` | 技術設計 | どう作るか設計 |
| `/kiro:spec-tasks` | タスク分解 | 実装前の分解 |
| `/kiro:spec-status` | 状態確認 | 進捗把握 |

### 実装

| コマンド | 用途 | いつ使う |
|---------|------|---------|
| `/impl-loop` | **TDD + レビューループ** | 仕様に基づく実装（**推奨**） |
| `/kiro:spec-impl` | ~~TDD実装~~ | **非推奨**: `/impl-loop` を使用 |

### 検証・品質

| コマンド | 用途 | いつ使う |
|---------|------|---------|
| `/verify` | 全検証チェック | 実装後（tsc, lint, test, build） |
| `/simplify` | コード簡潔化 | コミット前 |
| `/kiro:validate-impl` | 仕様適合性検証 | `/impl-loop` 内で自動実行 |
| `/kiro:validate-design` | 設計検証 | design.md 作成後 |

### Codex CLI レビュー（推奨）

| コマンド | 用途 |
|---------|------|
| `/codex-review --all` | 全レビュー（Code, UI, Security） |
| `/codex-review --code` | コードレビューのみ |
| `/codex-review --ui` | UI一貫性レビューのみ |
| `/codex-review --security` | セキュリティレビューのみ |

**impl-loop との統合**:
```bash
/impl-loop <feature> <tasks> --with-codex
```

**GitHub 統合**: PRを出すと Codex が自動レビュー（または `@codex` でメンション）。

### 開発・ビルド

| コマンド | 用途 |
|---------|------|
| `/dev` | 開発サーバー起動 |
| `/build` | EAS Build |
| `/prebuild` | Expo prebuild |
| `/typecheck` | TypeScript型チェック |

### UIモックアップ

| コマンド | 用途 |
|---------|------|
| `/ui-mockup` | HTMLモックアップ生成・プレビュー |

Design Phase後、Implementation前にモックアップで視覚的確認を推奨。

### Git・PR

| コマンド | 用途 |
|---------|------|
| `/commit-push-pr` | コミット → プッシュ → PR作成（一括実行） |
| `/commit` | コミットのみ作成 |

---

## 品質基準

### Warning/Error 0 ポリシー

```bash
npx tsc --noEmit        # エラー 0 必須
npm test -- --passWithNoTests  # テスト全パス
```

### 禁止事項

| 禁止 | 代替 |
|------|------|
| `// @ts-ignore` | 適切な型定義 |
| `any` 型 | `unknown` + narrowing |
| ハードコード日本語 | `t('key')` を使用 |
| `console.log` 残存 | 削除 or `__DEV__` ガード |

### TDD必須

`/impl-loop` 使用時は Kent Beck の TDD サイクルに従う：

1. **RED**: テストを先に書く（失敗することを確認）
2. **GREEN**: 最小限のコードでテストを通す
3. **REFACTOR**: コードを整理（テストは維持）

---

## ディレクトリ構造

```
.kiro/
  specs/              # 機能別仕様書
  settings/           # SDDルール・テンプレート
  steering/           # プロジェクト知識

.claude/
  skills/             # 利用可能なスキル
  commands/           # コマンド定義
    impl-loop.md      # 実装ループ（TDD統合）
    kiro/             # SDD コマンド
  agents/             # 専門エージェント
  rules/              # コーディングルール

mockup/               # HTMLモックアップ出力先

app/                  # Expo Router画面（作成後）
src/                  # ソースコード（作成後）
```

---

## 教訓の記録

過去のインシデントから学んだ教訓をここに記録する：

| 日付 | インシデント | 教訓 |
|------|-------------|------|
| - | - | - |

### AIへの注意
- **エアプ禁止**: 既存実装を確認せずに推測で回答しない
- **存在確認**: ファイル・機能の有無は必ずコードベースで確認
- **context7 MCP活用**: 外部ライブラリの使い方は推測せず、context7 MCPで公式ドキュメントを確認

---

## PostToolUse Hooks（自動化）

グローバル `~/.claude/settings.json` に設定推奨：

| Hook | 効果 |
|------|------|
| Prettier 自動フォーマット | 編集後に自動整形（CI失敗防止） |
| console.log 警告 | 本番コードへの混入を検知 |

> "auto-format code to prevent CI failures" - Boris Cherny
