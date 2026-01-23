---
description: Start the Expo development server
allowed-tools: Bash
---

# /dev - Start Development Server

## Overview

Start the Expo development server for local development.

## Basic Command

```bash
npx expo start
```

## Options

| Key | Action |
|-----|--------|
| `a` | Open Android emulator |
| `i` | Open iOS simulator |
| `r` | Reload the app |
| `m` | Toggle menu |
| `j` | Open debugger |

## Platform-Specific

### Android Only

```bash
npx expo start --android
```

### iOS Only

```bash
npx expo start --ios
```

## Troubleshooting

### Clear Cache

If experiencing issues with Metro bundler:

```bash
npx expo start --clear
```

### Reset Metro Cache

For persistent issues:

```bash
npx expo start --reset-cache
```

### Specific Port

If default port is busy:

```bash
npx expo start --port 8082
```

## Development Build

If using development build (not Expo Go):

```bash
npx expo start --dev-client
```

## Usage

```
/dev              # Start default
/dev --android    # Start with Android
/dev --clear      # Start with cache cleared
```
