---
description: TDD + 実装→レビュー→修正の強制ループを実行
allowed-tools: Task, Read, Glob, Grep, Bash, Edit, Write
argument-hint: <feature-name> [task-numbers]
---

# 実装ループ（TDD統合版）

## 概要

指定されたタスクに対して、**TDD（テスト駆動開発）** + **レビューループ**を実行します：

1. **TDD実装**（RED → GREEN → REFACTOR）
2. **品質チェック**（tsc, lint, test）
3. **レビュー**（code-reviewer）
4. **検証**（/kiro:validate-impl）

**すべてのレビューをクリアするまで、1-3を繰り返します。**

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
│  5. 問題があれば → 2に戻る                               │
│     問題がなければ → 6へ                                 │
│                                                         │
│  6. 実装検証                                             │
│     └─ /kiro:validate-impl <feature> <tasks>            │
│                                                         │
│  7. 完了報告                                             │
│     └─ tasks.md のチェックボックスを更新                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 使用方法

```bash
# Phase 1 の Task 1.1 を実装
/impl-loop intervention-system 1.1

# Phase 1 の複数タスクを実装
/impl-loop intervention-system 1.1,1.2,1.3

# 引数なしで対話的に選択
/impl-loop
```

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
