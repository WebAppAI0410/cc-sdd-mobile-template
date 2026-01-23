---
description: Run TypeScript type checking
allowed-tools: Bash, Read, Edit
---

# /typecheck - TypeScript Type Checking

## Overview

Run TypeScript type checking for the project.

## Basic Command

```bash
npx tsc --noEmit
```

## Expected Output

### Success

```
(no output - clean exit)
```

### Errors

```
src/components/MyComponent.tsx(10,5): error TS2322: Type 'string' is not assignable to type 'number'.
```

## Common Type Issues

### 1. Missing Types

Add type definitions to appropriate file:

```typescript
// src/types/index.ts
export interface MyNewType {
  id: string;
  name: string;
}
```

### 2. Theme Types

Ensure `useTheme()` is imported from correct path:

```typescript
import { useTheme } from '@/contexts/ThemeContext';
```

### 3. Navigation Types

For expo-router, ensure proper typing:

```typescript
import { useRouter } from 'expo-router';
import type { Href } from 'expo-router';

const router = useRouter();
router.push('/path' as Href);
```

### 4. Native Module Types

Check that native modules have TypeScript definitions.

## Fix Iteratively

If many errors, fix iteratively:

1. Run typecheck
2. Fix first error
3. Run typecheck again
4. Repeat until clean

## Watch Mode

For continuous type checking during development:

```bash
npx tsc --noEmit --watch
```

## Strict Mode Options

Check `tsconfig.json` for strict mode settings:

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

## Usage

```
/typecheck           # Run type check
/typecheck --watch   # Run in watch mode
```
