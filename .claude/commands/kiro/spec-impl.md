---
description: "[非推奨] /impl-loop を使用してください"
allowed-tools: Read
argument-hint: <feature-name> [task-numbers]
---

# /kiro:spec-impl (非推奨)

> **⚠️ このコマンドは非推奨です。`/impl-loop` を使用してください。**

## 移行ガイド

`/kiro:spec-impl` の機能は `/impl-loop` に統合されました。

### 変更点

| 旧コマンド | 新コマンド |
|-----------|-----------|
| `/kiro:spec-impl feature 1.1` | `/impl-loop feature 1.1` |
| `/kiro:spec-impl feature` | `/impl-loop feature` |

### `/impl-loop` の改善点

1. **TDD統合**: Kent Beck のRED → GREEN → REFACTORサイクルを維持
2. **レビューループ**: code-reviewer による自動レビュー
3. **検証**: /kiro:validate-impl との連携
4. **Steering読み込み**: .kiro/steering/ を自動参照

## 自動転送

このコマンドを実行した場合、`/impl-loop $1 $2` を使用してください。

```
/impl-loop $1 $2
```
