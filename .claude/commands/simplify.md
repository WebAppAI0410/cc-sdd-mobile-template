---
description: Simplify recently modified code for clarity and maintainability
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Task
---

# /simplify - Code Simplification Command

## Overview

Simplify recently modified code for clarity, consistency, and maintainability.

## When to Use

- After completing a feature implementation
- After `/impl-loop` completes
- Before creating a PR
- When code review suggests simplification

## Process

### 1. Identify Recent Changes

```bash
# Get recently modified files
git diff --name-only HEAD~1

# Or staged files
git diff --cached --name-only
```

### 2. Simplification Focus Areas

Review and simplify code focusing on:

1. **Reducing unnecessary complexity**
   - Remove unused variables/imports
   - Flatten deeply nested code
   - Extract repeated logic into functions

2. **Improving readability**
   - Use descriptive variable names
   - Add type annotations where missing
   - Break long functions into smaller ones

3. **Following project conventions**
   - Check CLAUDE.md for project-specific rules
   - Follow naming conventions
   - Use proper styling patterns

4. **Maintaining all functionality**
   - NEVER change what the code does
   - Run tests after simplification

### 3. Review Changes

- Show diff of simplifications
- Explain significant changes
- Preserve all functionality

## Principles (from Boris Cherny)

1. **Preserve Functionality**: Never change what the code does
2. **Apply Project Standards**: Follow CLAUDE.md conventions
3. **Enhance Clarity**: Reduce nesting, improve naming
4. **Maintain Balance**: Avoid over-simplification
5. **Focus Scope**: Only recently modified code

## Usage

```
/simplify              # Simplify recent changes
/simplify src/file.ts  # Simplify specific file
/simplify --all        # Simplify all staged files
```

## After Simplification

Run `/verify` to ensure all tests still pass.
