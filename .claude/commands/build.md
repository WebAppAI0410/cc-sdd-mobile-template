---
description: Build the app using EAS Build
allowed-tools: Bash, Read
---

# /build - EAS Build Command

## Overview

Build the mobile app using Expo Application Services (EAS).

## Pre-Build Checks

Before building, run verification:

```bash
# TypeScript check
npx tsc --noEmit

# Run tests
npm test -- --passWithNoTests
```

## Build Commands

### Android

```bash
# Preview build (APK for testing)
npx eas build --platform android --profile preview

# Production build (AAB for Play Store)
npx eas build --platform android --profile production
```

### iOS

```bash
# Preview build (for TestFlight)
npx eas build --platform ios --profile preview

# Production build (for App Store)
npx eas build --platform ios --profile production
```

### Both Platforms

```bash
npx eas build --platform all --profile preview
```

## Build Profiles

Defined in `eas.json`:

| Profile | Platform | Output | Use Case |
|---------|----------|--------|----------|
| `development` | Both | Dev Client | Local development |
| `preview` | Android | APK | Testing |
| `preview` | iOS | IPA | TestFlight |
| `production` | Android | AAB | Play Store |
| `production` | iOS | IPA | App Store |

## Local Build

Build locally without EAS servers:

```bash
# Android APK
npx eas build --platform android --profile preview --local

# iOS (requires macOS)
npx eas build --platform ios --profile preview --local
```

## Common Issues

1. **Build fails**: Check `eas.json` configuration
2. **Version mismatch**: Update `app.json` version
3. **Native module issues**: Run `npx expo prebuild --clean`
4. **Credentials**: Run `npx eas credentials`

## Usage

```
/build                          # Interactive platform selection
/build --android                # Build Android preview
/build --ios                    # Build iOS preview
/build --production --android   # Build Android for Play Store
```
