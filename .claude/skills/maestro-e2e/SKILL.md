---
description: This skill should be used when the user asks to "run E2E tests", "create Maestro test", "set up Maestro", "write flow file", "debug E2E test", or works with the .maestro/ directory, Maestro Studio, or mobile app E2E testing.
---

# Maestro E2E Testing Skill

Expo/React Native アプリの E2E テスト設定・実行ガイド。

---

## 1. 環境セットアップ

### 1.1 前提条件

| 要件 | 確認コマンド | 備考 |
|------|-------------|------|
| Java 17+ | `java -version` | 必須 |
| Android SDK | `adb --version` | Androidテスト用 |
| Node.js | `node --version` | Expoビルド用 |
| EAS CLI | `eas --version` | development build用 |

### 1.2 Maestroインストール

#### macOS (Homebrew)

```bash
brew tap mobile-dev-inc/tap
brew install maestro
```

#### macOS/Linux/WSL2 (curl)

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash

# シェル再起動後
maestro --version
```

#### Maestro Studio Desktop（GUI）

| OS | ダウンロード |
|----|-------------|
| Windows | https://studio.maestro.dev/MaestroStudio.exe |
| macOS | https://studio.maestro.dev/MaestroStudio.dmg |
| Linux | https://studio.maestro.dev/MaestroStudio.AppImage |

---

## 2. アプリのビルドとインストール

### 2.1 Development Build作成（Expo/EAS）

```bash
# Android用
eas build --profile development --platform android

# iOS用（macOS必須）
eas build --profile development --platform ios
```

**重要**:
- Expo Goではネイティブモジュールが動作しない
- Maestroテストには**development build**または**release build**が必須

### 2.2 APKのインストール

```bash
# エミュレータ起動確認
adb devices

# APKインストール
adb install /path/to/app.apk
```

---

## 3. プロジェクト構成

### 3.1 ディレクトリ構造

```
.maestro/
├── config.yaml          # ワークスペース設定
├── README.md            # テストガイド
└── flows/
    ├── onboarding-flow.yaml
    └── main-flow.yaml
```

### 3.2 config.yaml

```yaml
# .maestro/config.yaml
appId: com.example.app  # 実際のアプリIDに変更

flows:
  - flows/*.yaml

executionOrder: sequential
timeout: 30000

# プラットフォーム固有設定
ios:
  deviceName: "iPhone 15 Pro"

android:
  deviceName: "Pixel 7"

output:
  format: "junit"
  path: "./test-results"
```

---

## 4. フローの書き方

### 4.1 基本構造

```yaml
appId: com.example.app
---
# アプリ起動
- launchApp

# 要素タップ（テキストで指定）
- tapOn: "次へ"

# 要素タップ（testIDで指定）
- tapOn:
    id: "continue-button"

# テキスト入力
- tapOn: "メールアドレス"
- inputText: "test@example.com"
- hideKeyboard

# アサーション
- assertVisible: "ようこそ"
- assertNotVisible: "エラー"

# スクロール
- scrollUntilVisible:
    element: "利用規約に同意"
    direction: DOWN

# 待機
- extendedWaitUntil:
    visible: "完了"
    timeout: 10000
```

### 4.2 React Native / Expo での testID

```tsx
// コンポーネントに testID を追加
<Button
  testID="start-button"
  title="開始"
  onPress={handleStart}
/>

<TextInput
  testID="email-input"
  placeholder="メールアドレス"
/>
```

```yaml
# フローで使用
- tapOn:
    id: "start-button"

- tapOn:
    id: "email-input"
- inputText: "user@example.com"
```

### 4.3 主要コマンド一覧

| カテゴリ | コマンド | 説明 |
|---------|---------|------|
| **タップ** | `tapOn` | 要素をタップ |
| | `doubleTapOn` | ダブルタップ |
| | `longPressOn` | 長押し |
| **スクロール** | `scroll` | スクロール |
| | `scrollUntilVisible` | 要素が見えるまでスクロール |
| **入力** | `inputText` | テキスト入力 |
| | `eraseText` | テキスト削除 |
| | `hideKeyboard` | キーボード非表示 |
| **アプリ制御** | `launchApp` | アプリ起動 |
| | `killApp` | アプリ終了 |
| | `clearState` | アプリ状態クリア |
| **アサーション** | `assertVisible` | 表示確認 |
| | `assertNotVisible` | 非表示確認 |
| **待機** | `extendedWaitUntil` | 条件まで待機 |
| | `waitForAnimationToEnd` | アニメーション完了待ち |

---

## 5. テスト実行

### 5.1 基本実行

```bash
# 全テスト実行
maestro test .maestro/

# 個別フロー実行
maestro test .maestro/flows/onboarding-flow.yaml
```

### 5.2 デバッグモード

```bash
# ステップごとに停止
maestro test --debug .maestro/flows/onboarding-flow.yaml

# 要素階層を表示
maestro hierarchy
```

### 5.3 Maestro Studio起動

```bash
# ブラウザベースのインタラクティブUI
maestro studio
```

### 5.4 Continuous Mode

```bash
# フロー変更を監視して自動再実行
maestro test --continuous .maestro/flows/onboarding-flow.yaml
```

---

## 6. 条件付きフロー

### 6.1 runFlow with when

```yaml
# オンボーディング画面が表示されている場合のみ実行
- runFlow:
    when:
      visible: "始める"
    commands:
      - tapOn: "始める"
      - waitForAnimationToEnd
```

### 6.2 オプショナルアサーション

```yaml
# 権限画面が出るかもしれない場合
- assertVisible:
    text: "使用状況へのアクセスを許可"
    optional: true

# オプショナル要素のタップ
- tapOn:
    text: "許可する"
    optional: true
```

---

## 7. 日本語・Unicode対応

### 7.1 Android制限事項

**重要**: MaestroはAndroidでUnicode入力をサポートしていません。

```yaml
# ❌ Androidで失敗する
- inputText: "テストユーザー"

# ✅ ASCII文字のみ使用
- inputText: "TestUser"
```

### 7.2 日本語テキスト要素のタップ

日本語テキストの**表示・検索・タップ**は可能です：

```yaml
# ✅ 日本語テキストのタップは動作する
- tapOn: "始める"
- tapOn: "次へ"
- assertVisible: "設定"
```

---

## 8. トラブルシューティング

| 問題 | 解決方法 |
|------|---------|
| デバイスが見つからない | `adb devices` で接続確認 |
| 要素が見つからない | `maestro hierarchy` で要素構造を確認 |
| タイムアウト | `config.yaml` の `timeout` 値を増加 |
| アプリが起動しない | `adb shell pm list packages` でインストール確認 |

---

## 9. クイックリファレンス

```bash
maestro test .maestro/                    # 全テスト
maestro test --debug flow.yaml            # デバッグモード
maestro hierarchy                          # 要素確認
maestro studio                             # Studio起動
maestro test --continuous .maestro/       # 継続モード
```
