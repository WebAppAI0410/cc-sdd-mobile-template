---
description: Run Expo prebuild to generate native projects
allowed-tools: Bash, Read, Glob
---

# /prebuild - Generate Native Projects

## Overview

Generate or regenerate native Android/iOS projects using Expo prebuild.

## Clean Prebuild

Recommended for most cases - removes existing native folders and regenerates:

```bash
npx expo prebuild --clean
```

## Platform-Specific

### Android Only

```bash
npx expo prebuild --platform android --clean
```

### iOS Only

```bash
npx expo prebuild --platform ios --clean
```

## When to Use

Run prebuild when:

- Adding native modules to the project
- Changing native config in `app.json` or `app.config.js`
- Updating Expo SDK version
- Native build fails unexpectedly
- After modifying `plugins` in app config

## After Prebuild

### Verify Native Configuration

Check that native projects are properly generated:

```bash
# List generated directories
ls -la android/ ios/

# Check Android build.gradle
cat android/app/build.gradle | head -50

# Check iOS Podfile
cat ios/Podfile | head -50
```

### Install iOS Dependencies

After iOS prebuild:

```bash
cd ios && pod install && cd ..
```

## Prebuild Without Clean

Keep existing native modifications (use with caution):

```bash
npx expo prebuild
```

## Common Issues

1. **Conflicting native code**: Use `--clean` flag
2. **Missing dependencies**: Run `npm install` first
3. **Pod install fails**: Delete `ios/Pods` and `ios/Podfile.lock`, then retry
4. **Gradle sync fails**: Check Java version and Android SDK

## Usage

```
/prebuild                   # Full clean prebuild
/prebuild --android         # Android only
/prebuild --ios             # iOS only
/prebuild --no-clean        # Keep existing native code
```
