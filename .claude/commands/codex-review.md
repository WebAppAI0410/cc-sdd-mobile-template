---
description: Codex CLI による反復レビューを実行し、ok: true まで自動修正→再レビューを繰り返す
allowed-tools: Bash, Read, Write, Edit, Skill
argument-hint: [--no-loop] [--code] [--ui] [--security] [--all]
---

# Codex 反復レビュー

Codex CLI (GPT-5.2) を使用した自動コードレビューを実行します。

## 概要

**codex-review スキルを使用**して、Codexによるレビュー→Claude修正→再レビューの反復ループを実行し、`ok: true`になるまで自動的に問題を解消します。

```
[規模判定] → small:  diff ──────────────────→ [修正ループ]
          → medium: arch → diff ───────────→ [修正ループ]
          → large:  arch → diff並列 → cross-check → [修正ループ]

[修正ループ] = Codexレビュー → ok: false → Claude修正 → 再レビュー（最大5回）
```

## 使用方法

```bash
# 反復レビューを実行（デフォルト）
/codex-review

# 従来の単発レビュー（反復なし）
/codex-review --no-loop

# 特定の観点のみ（反復ループ付き）
/codex-review --code       # コードレビューのみ
/codex-review --ui         # UI一貫性レビューのみ
/codex-review --security   # セキュリティレビューのみ

# 複数選択
/codex-review --code --security
```

### フラグオプション

| フラグ | 説明 |
|--------|------|
| `--no-loop` | 反復ループを無効化（従来の単発レビュー） |
| `--code` | コードレビューのみ |
| `--ui` | UI一貫性レビューのみ |
| `--security` | セキュリティレビューのみ |
| `--all` | 全カテゴリをレビュー（デフォルト） |

## 実行フロー

### Step 1: 規模判定

```bash
git diff HEAD --stat
git diff HEAD --name-status --find-renames
```

| 規模 | 基準 | 戦略 |
|-----|------|-----|
| small | ≤3ファイル、≤100行 | diff |
| medium | 4-10ファイル、100-500行 | arch → diff |
| large | >10ファイル、>500行 | arch → diff並列 → cross-check |

### Step 2: Codex 反復レビュー

**codex-review スキルを使用**して反復レビューを実行：

```bash
# --no-loop が指定されていなければ反復レビュー
if [[ "$*" != *"--no-loop"* ]]; then
  # codex-review スキルを使用
  # ok: true まで最大5回反復
fi
```

**Codex実行コマンド:**
```bash
codex exec --sandbox read-only "<PROMPT>"
```

### Step 3: 修正ループ

`ok: false`の場合、以下を最大5回繰り返す：

1. Codexの`issues`を解析 → 修正計画
2. Claude Codeが修正（最小差分のみ）
3. テスト/リンタ実行
4. Codexに再レビュー依頼

**停止条件:**
- `ok: true`
- max_iters（5回）到達
- テスト2回連続失敗

### Step 4: 統合レポート生成

```markdown
## Codexレビュー結果
- 規模: medium（6ファイル、280行）
- 反復: 2/5 / ステータス: ok

### 修正履歴
- auth.ts: 認可チェック追加
- api.ts: エラーハンドリング改善

### Advisory（参考）
- utils.ts: 関数名がやや冗長、リファクタ推奨

### 未解決（あれば）
- なし
```

## Codex出力スキーマ

```json
{
  "ok": true,
  "phase": "arch|diff|cross-check",
  "summary": "レビューの要約",
  "issues": [
    {
      "severity": "blocking|advisory",
      "category": "correctness|security|perf|maintainability|testing|style",
      "file": "src/auth.ts",
      "lines": "42-45",
      "problem": "問題の説明",
      "recommendation": "修正案"
    }
  ],
  "notes_for_next_review": "次回レビューへのメモ"
}
```

**severity:**
- `blocking`: 修正必須。1件でも`ok: false`
- `advisory`: 推奨・警告。`ok: true`でもレポートに記載

## 従来モード（--no-loop）

`--no-loop`フラグを指定すると、従来の単発レビューを実行：

```bash
mkdir -p /tmp/codex-review

# Code Review
codex exec "Code Review:
1) Run 'npx tsc --noEmit' and report all TypeScript errors
2) Find all 'any' type usages with file and line numbers
3) Check for React Hooks violations
4) Find hardcoded Japanese text outside i18n
Format: File:Line - Issue - Severity (error/warning/info)" \
> /tmp/codex-review/code-review.txt 2>&1 &

# UI Consistency Review
codex exec "UI Consistency Review:
Check all components against design system
Find:
1) Hardcoded colors not using useTheme()
2) Hardcoded spacing values (padding, margin, gap)
3) Inconsistent border radius usage
4) Non-theme typography
Format: File:Line - Issue" \
> /tmp/codex-review/ui-review.txt 2>&1 &

# Security Review
codex exec "Security Review:
1) Run 'npm audit' to check vulnerabilities
2) Search for hardcoded secrets, API keys, or tokens
3) Check for sensitive data in console.log statements (missing __DEV__ guard)
4) Find exposed credentials in config files
Format: File:Line - Issue - Severity (high/medium/low)" \
> /tmp/codex-review/security-review.txt 2>&1 &

wait
```

## 統合ワークフロー

`/impl-loop` と連携して使用（デフォルトで有効）:

```
/impl-loop <feature> [tasks]
├─ Claude: TDD実装 + レビュー
└─ Codex: codex-review スキル（反復ループ）
    ├─ ok: false → Claude修正 → 再レビュー
    └─ ok: true → 完了
```

## 注意事項

- Codex CLI がインストール済みであること（`codex --version`で確認）
- ネットワーク接続が必要
- 大規模変更（>500行）は並列処理で時間短縮
