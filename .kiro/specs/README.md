# Specs Directory

このディレクトリには機能ごとの仕様書を格納します。

## 構造

```
specs/
└── <feature-name>/
    ├── requirement.md    # 要件定義（なぜ作るか、何を作るか）
    ├── design.md         # 設計（どう作るか）
    └── tasks.md          # タスク分解（実装ステップ）
```

## 作成方法

1. `/kiro:spec-init <feature-name>` - 新しい機能の仕様書を作成
2. `/kiro:spec-design` - requirement.mdからdesign.mdを生成
3. `/kiro:spec-tasks` - design.mdからtasks.mdを生成

## 例

```
specs/
├── authentication/
│   ├── requirement.md
│   ├── design.md
│   └── tasks.md
└── user-profile/
    ├── requirement.md
    ├── design.md
    └── tasks.md
```

## 注意

- 各機能は独立したディレクトリで管理
- requirement.md → design.md → tasks.md の順で作成
- 仕様書を更新したらtasks.mdも再生成すること
