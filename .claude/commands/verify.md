---
description: Run all verification checks (typecheck, lint, test, build)
allowed-tools: Bash, Read, Glob
---

# /verify - Universal Verification Command

## Overview

Run all available verification checks for the current project.

> "give Claude a way to verify its work. If Claude has that feedback loop, it will 2-3x the quality of the final result." - Boris Cherny

## Verification Strategy

### 1. Detect Project Type

Analyze package.json, tsconfig.json, etc. to determine project type.

### 2. Run Available Checks

Execute ALL applicable checks in order:

#### React Native / Expo Projects (Default)

```bash
# Type checking
npx tsc --noEmit

# Linting (if eslint config exists)
npm run lint 2>/dev/null || echo "No lint script configured"

# Tests
npm test -- --passWithNoTests 2>/dev/null || echo "No tests configured"

# Expo doctor
npx expo doctor 2>/dev/null || echo "Expo doctor skipped"
```

#### Build Verification (Optional)

```bash
# Only if requested
npm run build 2>/dev/null || echo "No build script"
```

### 3. Report Results

Summarize:
- Passed checks
- Failed checks with error details
- Skipped checks (not applicable)

### 4. Auto-Fix Mode

If any check fails:
1. Analyze the error message
2. Propose fixes
3. Apply fixes (with user confirmation)
4. Re-run failed checks
5. Repeat until all pass or max iterations reached

## Usage Examples

```
/verify              # Run all checks
/verify --fix        # Auto-fix mode
/verify typecheck    # Run only type checking
/verify test         # Run only tests
```

## Integration with Other Commands

- After `/impl-loop`: automatically run `/verify`
- After code changes: run `/verify --fix`
- Before commit: run `/verify` as pre-commit check
