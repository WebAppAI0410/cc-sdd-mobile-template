---
description: Complete PR workflow (verify -> simplify -> review -> commit)
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Task
---

# /pr-workflow - Complete PR Creation Workflow

## Overview

Boris Cherny-style verification -> simplification -> review -> commit flow.

## Execution Steps

### Phase 1: Verification

Run all verification checks first:

```bash
# TypeScript
npx tsc --noEmit

# Lint
npm run lint 2>/dev/null || echo "No lint script"

# Tests
npm test -- --passWithNoTests

# Expo doctor (for React Native projects)
npx expo doctor 2>/dev/null || echo "Expo doctor skipped"
```

**Repeat fixes until all checks pass.**

### Phase 2: Simplification

Once verification passes, simplify recent changes:

- Focus on recently modified files only
- Reduce unnecessary complexity
- Improve readability
- Preserve all functionality

### Phase 3: Review

Final review checklist:

- Design patterns are appropriate
- Security considerations addressed
- CLAUDE.md conventions followed
- No hardcoded secrets or sensitive data

### Phase 4: Commit

```bash
# Stage changes (prefer specific files over -A)
git add <specific-files>

# Commit with descriptive message
git commit -m "feat: <description>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"

# Push and create PR
git push -u origin HEAD
gh pr create --fill
```

## Usage

```
/pr-workflow
```

This runs the complete verify -> simplify -> review -> commit flow.

## Important Notes

- Human confirmation is required at each phase
- Code simplification runs only once
- Stop if verification fails
- Never auto-chain without confirmation
