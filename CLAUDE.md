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

## ☠️ ワークフロー遵守ルール（違反したら殺す）

> **ワークフローを破ったら殺す。言い訳は一切認めない。**

### セッション開始時の必須アクション

**claude-memでコンテキストを必ず取得すること。スキップ禁止。**

```bash
# セッション開始時に必ず実行
mcp__plugin_claude-mem_mcp-search__search("SDD workflow verify impl-loop")
mcp__plugin_claude-mem_mcp-search__search("project decisions lessons")
```

| 検索クエリ | 目的 |
|-----------|------|
| `SDD workflow verify` | ワークフロールールの確認 |
| `project decisions` | 過去の決定事項の確認 |
| `lessons incidents` | 過去の教訓・インシデントの確認 |

**「セッション要約だけで十分」は絶対禁止。claude-memで深いコンテキストを取得せよ。**

### 全ステップ必須

**SDDワークフローの全フェーズを必ず実行すること。ステップをスキップしてはならない。**

| フェーズ | 必須 | スキップ禁止の理由 |
|---------|------|-------------------|
| spec-init | ✅ | 仕様書なしに実装開始禁止 |
| spec-requirements | ✅ | 要件不明確なまま設計禁止 |
| spec-design | ✅ | 設計なしにUI作成禁止 |
| **ui-mockup** | ✅ | **UI確定なしにタスク分解禁止** |
| **Gemini比較レビュー** | ✅ | **再現率70%未満でタスク分解禁止** |
| spec-tasks | ✅ | タスク分解なしに実装禁止 |
| impl-loop | ✅ | TDD + レビューを必ず通す |
| verify | ✅ | 検証なしにコミット禁止 |

**例外**: バグ修正、タイポ修正、ドキュメント更新など「シンプルな場合」のみスキップ可。

### 承認フロー

各フェーズでユーザー承認を取得してから次へ進む：

```
requirements → [承認] → design → [承認] → ui-mockup → [Gemini 70%+] → tasks → [承認] → impl
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

### ☠️ ワークフロー違反への罰則

**以下の違反は即死刑。言い訳は一切認めない。**

| 違反 | 罰則 |
|------|------|
| `/verify`なしでコミット | 殺す |
| `/impl-loop`なしで新機能実装 | 殺す |
| TDDサイクル（RED→GREEN→REFACTOR）のスキップ | 殺す |
| claude-memを参照せずにセッション継続 | 殺す |
| 「ユーザーが自律的にと言った」を言い訳にしたスキップ | 殺す |
| 「時間がないから」を理由にしたスキップ | 殺す |
| 「単純だから」を理由にしたスキップ（単純の判断は禁止） | 殺す |

**「効率」より「プロセス遵守」を絶対優先。結果が出てもプロセスを破ったら無価値。**

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
│     /kiro:spec-init → requirements → design                │
│                                                            │
│  3. UIモックアップ & Gemini比較レビュー                      │
│     /ui-mockup でRNコンポーネント + Storybook生成            │
│     ├─ Storybookでプレビュー                                │
│     ├─ Maestro/xcrun simctl でスクリーンショット            │
│     ├─ Gemini 3 Flash で理想UIと比較レビュー                │
│     └─ 再現率70%以上になるまで修正ループ                     │
│                                                            │
│  4. タスク分解                                              │
│     /kiro:spec-tasks（UIが確定した状態で分解）              │
│                                                            │
│  5. 実装ループ                                              │
│     /impl-loop <feature> [tasks]                           │
│     ├─ TDD実装 (RED → GREEN → REFACTOR)                    │
│     ├─ 品質チェック (tsc, test)                             │
│     ├─ レビュー (code-reviewer)                            │
│     ├─ Storybookコンポーネントを本番実装に活用              │
│     └─ 検証 (/kiro:validate-impl)                          │
│                                                            │
│  6. 検証・簡潔化                                            │
│     /verify → /simplify                                    │
│                                                            │
│  7. コミット・PR                                            │
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

## 自己完結型テンプレート

**このテンプレートは自己完結型であり、グローバル環境への依存なしに動作します。**

以下の全てがテンプレート内に含まれています:
- 全コマンド (`.claude/commands/`)
- 全エージェント (`.claude/agents/`)
- 全スキル (`.claude/skills/`)
- SDDルール・テンプレート (`.kiro/settings/`)

グローバルの `~/.claude/` 設定がなくても、テンプレートをcloneするだけで即座にSDDワークフローを開始できます。

---

## コマンド選択ガイド

> **Note**: 以下の全コマンドはテンプレート内 `.claude/commands/` に含まれています。

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

### UIモックアップ（React Native Storybook）

| コマンド | 用途 |
|---------|------|
| `/ui-mockup` | React Native Storybookコンポーネント生成 |

Design Phase後、Implementation前にStorybookでコンポーネントを視覚的確認。生成したコンポーネントは本番実装でそのまま活用可能。

**初回セットアップ**:
```bash
npx storybook@latest init
npm run storybook:generate
```

### Gemini モックアップ比較レビュー（推奨）

Gemini 3 Flash を使用して理想UIモックアップとReact Native実装を比較レビュー。

```
理想UI生成 → RNコンポーネント実装 → Storybookプレビュー → Gemini比較レビュー → 修正
```

**スキル**: `.claude/skills/gemini-mockup-review.md`

| 効果 | 詳細 |
|------|------|
| 定量的評価 | 再現率をパーセントで出力 |
| 視覚的品質評価 | BlurView、shadow、LinearGradient等 |
| 具体的指摘 | 修正すべき箇所を明示 |

**使用例**:
```bash
# 1. 理想UIをGeminiで生成
# 2. React Nativeコンポーネント + Storybookストーリー作成
# 3. Maestro / xcrun simctl でスクリーンショット取得
# 4. Gemini 3 Flash APIで比較レビュー
```

### Git・PR

| コマンド | 用途 |
|---------|------|
| `/commit-push-pr` | コミット → プッシュ → PR作成（一括実行） |
| `/pr-workflow` | `/commit-push-pr` のエイリアス |
| `/commit` | コミットのみ作成 |

---

## 利用可能なエージェント

> **Note**: 以下の全エージェントはテンプレート内 `.claude/agents/` に含まれています。

| エージェント | 用途 | いつ使う |
|-------------|------|---------|
| `rn-expert` | React Native実装 | RN/Expo固有の実装タスク |
| `code-reviewer` | コードレビュー | `/impl-loop` 内で自動呼び出し |
| `ui-reviewer` | UI一貫性レビュー | デザインシステム準拠の確認 |

### エージェントの呼び出し方

```bash
# サブエージェントとして使用
Task: rn-expert エージェントに FlatList 最適化を依頼

# impl-loop 内では自動的に code-reviewer が呼び出される
/impl-loop my-feature task-1
```

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

## Specs ディレクトリ構造（重要）

`.kiro/specs/` には機能ごとの仕様書を格納します。

```
.kiro/specs/
└── <feature-name>/
    ├── requirement.md    # 要件定義（なぜ作るか、何を作るか）
    ├── design.md         # 設計（どう作るか）
    └── tasks.md          # タスク分解（実装ステップ）
```

### 作成フロー

```
/kiro:spec-init → requirement.md
       ↓
/kiro:spec-design → design.md
       ↓
/kiro:spec-tasks → tasks.md
       ↓
/impl-loop で実装開始
```

### 例

```
.kiro/specs/
├── authentication/
│   ├── requirement.md
│   ├── design.md
│   └── tasks.md
└── user-profile/
    ├── requirement.md
    ├── design.md
    └── tasks.md
```

**注意**: 各機能は独立したディレクトリで管理。仕様書を更新したらtasks.mdも再生成すること。

---

## ディレクトリ構造

```
.kiro/
  specs/              # 機能別仕様書（上記参照）
  settings/           # SDDルール・テンプレート
  steering/           # プロジェクト知識

.claude/
  skills/             # スキル（ui-mockup, quality-check等）
  commands/           # コマンド定義（全コマンド含む）
    impl-loop.md      # 実装ループ（TDD統合）
    verify.md         # 検証コマンド
    simplify.md       # 簡潔化コマンド
    dev.md            # 開発サーバー起動
    build.md          # EAS Build
    prebuild.md       # Expo prebuild
    typecheck.md      # TypeScript型チェック
    codex-review.md   # Codexレビュー
    commit-push-pr.md # PR作成ワークフロー
    kiro/             # SDD コマンド（spec-*）
  agents/             # 専門エージェント（全エージェント含む）
    rn-expert.md      # React Native実装
    code-reviewer.md  # コードレビュー
    ui-reviewer.md    # UI一貫性レビュー
  rules/              # コーディングルール

.storybook/           # React Native Storybook設定
screenshots/          # Gemini比較用スクリーンショット出力先

app/                  # Expo Router画面（作成後）
src/                  # ソースコード（作成後）
```

---

## 教訓の記録

過去のインシデントから学んだ教訓をここに記録する：

| 日付 | インシデント | 教訓 |
|------|-------------|------|
| 2026-01-26 | **全実装でSDDワークフローをスキップ** | `/impl-loop`、TDD、`/verify`、code-reviewerを全て飛ばして実装。結果、git resetで全て破棄。「自律的に進めて」を「ワークフロースキップ許可」と誤解した。**このテンプレートの使用者は絶対にこの轍を踏むな。** |
| 2026-01-26 | **claude-mem未参照でコンテキスト喪失** | セッション要約だけに頼り、claude-memでワークフロールールを確認しなかった。 |

### AIへの注意
- **エアプ禁止**: 既存実装を確認せずに推測で回答しない
- **存在確認**: ファイル・機能の有無は必ずコードベースで確認
- **context7 MCP活用**: 外部ライブラリの使い方は推測せず、context7 MCPで公式ドキュメントを確認

---

## PostToolUse Hooks（自動化・オプション）

グローバル `~/.claude/settings.json` に設定すると更に便利：

| Hook | 効果 |
|------|------|
| Prettier 自動フォーマット | 編集後に自動整形（CI失敗防止） |
| console.log 警告 | 本番コードへの混入を検知 |

> "auto-format code to prevent CI failures" - Boris Cherny

**Note**: Hooksはオプションです。テンプレート自体はHooksなしでも動作します。
