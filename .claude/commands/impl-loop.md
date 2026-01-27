---
description: TDD + 実装→レビュー→修正の強制ループを実行
allowed-tools: Task, Read, Glob, Grep, Bash, Edit, Write, Skill
argument-hint: <feature-name> [task-numbers] [--no-codex]
---

# 実装ループ（TDD統合版）

## 概要

指定されたタスクに対して、**TDD（テスト駆動開発）** + **レビューループ**を実行します：

1. **TDD実装**（RED → GREEN → REFACTOR）
2. **品質チェック**（tsc, lint, test）
3. **レビュー**（code-reviewer）
4. **Codex反復レビュー**（codex-review スキル使用、ok: true まで最大5回）
5. **検証**（/kiro:validate-impl）

**すべてのレビューをクリアするまで、1-4を繰り返します。**

> Note: Codex反復レビューはデフォルトで有効。`--no-codex` フラグで無効化可能。

---

## 実行フロー

```
┌─────────────────────────────────────────────────────────┐
│                    実装ループ開始                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. コンテキスト読み込み                                 │
│     ├─ .kiro/specs/<feature>/ (requirements, design, tasks)│
│     └─ .kiro/steering/ (product, tech, structure)       │
│                                                         │
│  2. TDD実装フェーズ                                      │
│     ┌─────────────────────────────────────────────┐     │
│     │ Kent Beck's TDD Cycle:                      │     │
│     │                                             │     │
│     │  RED: テストを先に書く（失敗する）           │     │
│     │       ↓                                     │     │
│     │  GREEN: 最小限のコードでテストを通す        │     │
│     │       ↓                                     │     │
│     │  REFACTOR: コードを整理（テストは維持）     │     │
│     └─────────────────────────────────────────────┘     │
│                                                         │
│  3. 品質チェック                                         │
│     ├─ TypeScript型チェック: npx tsc --noEmit           │
│     ├─ Lintチェック: 必要に応じて                        │
│     └─ テスト実行: npm test (全テスト PASS 必須)         │
│                                                         │
│  4. コードレビュー                                       │
│     └─ Task(code-reviewer): 品質・設計レビュー          │
│                                                         │
│  5. Codex反復レビュー（デフォルト有効）                   │
│     ├─ codex-review スキルを使用                         │
│     ├─ ok: true まで最大5回反復                          │
│     └─ --no-codex で無効化可能                           │
│                                                         │
│  6. 問題があれば → 2に戻る                               │
│     問題がなければ → 7へ                                 │
│                                                         │
│  7. 実装検証                                             │
│     └─ /kiro:validate-impl <feature> <tasks>            │
│                                                         │
│  8. 完了報告                                             │
│     └─ tasks.md のチェックボックスを更新                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 使用方法

```bash
# Phase 1 の Task 1.1 を実装（Codex反復レビュー付き）
/impl-loop intervention-system 1.1

# Phase 1 の複数タスクを実装
/impl-loop intervention-system 1.1,1.2,1.3

# Codexレビューを無効化して実装（Claudeレビューのみ）
/impl-loop intervention-system 1.1 --no-codex

# 引数なしで対話的に選択
/impl-loop
```

### フラグオプション

| フラグ | 説明 |
|--------|------|
| `--no-codex` | Codex反復レビューを無効化（Claudeレビューのみ実行） |
| `--with-codex` | （互換性維持）Codexレビューを有効化（デフォルトで有効なので不要） |

---

## 実行手順

### Step 1: コンテキスト読み込み

1. `.kiro/specs/$1/` 全体を読み込む（tasks.md, requirements.md, design.md）
2. `.kiro/steering/` 全体を読み込む（product.md, tech.md, structure.md）
3. 指定されたタスク番号（$2）の内容を抽出
4. タスクが承認済みか確認

### Step 2: TDD実装

```
実装対象:
- Feature: $1
- Tasks: $2

TDDサイクル（各タスクごと）:
1. RED:    テストを先に書く（失敗することを確認）
2. GREEN:  最小限のコードでテストを通す
3. REFACTOR: コードを整理（テストは維持）

参照仕様:
- .kiro/specs/$1/requirements.md
- .kiro/specs/$1/design.md
- .kiro/specs/$1/tasks.md
- .kiro/steering/ (プロジェクト知識)

制約:
- テストを先に書く（TDD必須）
- TypeScript厳密型
- i18n対応（ハードコード日本語禁止）
```

### Step 3: 品質チェック

以下のコマンドを順次実行：

```bash
# TypeScript型チェック
npx tsc --noEmit

# テスト実行
npm test -- --passWithNoTests
```

**warning/errorが0になるまで修正を繰り返す。**

### Step 4: コードレビュー

Task tool で code-reviewer を起動。

### Step 4.5: Codex 反復レビュー（デフォルト有効）

**デフォルトで有効**。`--no-codex` フラグで無効化可能。

**codex-review スキルを使用**して反復レビューを実行：

1. 規模判定（git diff --stat）
2. Codexレビュー実行
3. `ok: false` の場合 → Claude が修正 → 再レビュー（最大5回）
4. `ok: true` になれば完了

**停止条件:**
- `ok: true`
- max_iters（5回）到達
- テスト2回連続失敗

**統合のメリット:**
- Claude と Codex の異なる視点でレビュー
- 型安全性、セキュリティ、UI一貫性を網羅的にチェック
- 反復ループで品質を収束

**`--no-codex` フラグ指定時:** Codex レビューはスキップされ、Claude レビューのみ実行。

### Step 5: 問題対応

レビューで問題が検出された場合：
1. 問題を修正
2. Step 3 に戻る

### Step 6: 実装検証

```bash
/kiro:validate-impl $1 $2
```

GO判定が出るまで修正を繰り返す。

### Step 7: 完了

1. `tasks.md` の該当タスクを `[x]` に更新
2. 実装サマリーを出力

---

## 品質基準

### 必須クリア項目

| 項目 | 基準 |
|------|------|
| TDD | テストが先に書かれている |
| TypeScript | `tsc --noEmit` エラー0 |
| テスト | `npm test` 全PASS |
| コードレビュー | 重大な問題なし |
| Codexレビュー | `ok: true`（blocking issue なし） |
| 要件充足 | validate-impl で GO |

### 推奨項目

| 項目 | 基準 |
|------|------|
| テストカバレッジ | 新規コードに対するテスト 80%以上 |
| i18n | 全文字列が locale ファイル参照 |
| リファクタリング | 重複コードなし |

---

## 出力形式

```markdown
# 実装ループ完了レポート

## 概要
- Feature: <feature-name>
- Tasks: 1.1, 1.2
- ループ回数: 2回
- 最終結果: GO

## 実装内容
- [x] Task 1.1: <task description>
- [x] Task 1.2: <task description>

## 品質チェック結果
- TypeScript: PASS
- Lint: PASS
- Tests: PASS (5/5)

## レビュー結果
- Code Review: PASS

## 次のステップ
- Task 1.3 の実装を推奨
```
