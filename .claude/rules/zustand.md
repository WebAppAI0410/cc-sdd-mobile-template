---
paths:
  - "src/stores/**/*.ts"
  - "src/stores/**/*.tsx"
---

# Zustand State Management Rules

## Store Structure

### Required Middleware Stack
```typescript
import { create } from 'zustand';
import { devtools, persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const useMyStore = create<MyState>()(
  devtools(
    persist(
      (set, get) => ({
        // state and actions
      }),
      {
        name: 'my-store',
        storage: createJSONStorage(() => AsyncStorage),
        partialize: (state) => ({
          // Only persist necessary fields
        }),
      }
    ),
    { name: 'MyStore' }
  )
);
```

### State Interface Pattern
```typescript
interface MyState {
  // 1. Data (readonly from outside)
  items: Item[];
  isLoading: boolean;

  // 2. Actions (imperative verbs)
  addItem: (item: Item) => void;
  removeItem: (id: string) => void;
  reset: () => void;
}
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Store hook | `use[Feature]Store` | `useAppStore`, `useAIStore` |
| Boolean state | `is[State]` or `has[State]` | `isLoading`, `hasCompletedOnboarding` |
| Array state | Plural noun | `messages`, `badges`, `targetApps` |
| Set action | `set[Property]` | `setUserName`, `setGoalMinutes` |
| Toggle action | `toggle[Property]` | `toggleTheme` |
| Add action | `add[Item]` | `addMessage`, `addBadge` |
| Remove action | `remove[Item]` | `removeTargetApp` |
| Reset action | `reset` or `reset[Section]` | `reset`, `resetConversation` |

## Persistence Rules

### Always Partialize
Never persist the entire state. Explicitly select persisted fields:

```typescript
// ✅ Good: Explicit persistence
partialize: (state) => ({
  userName: state.userName,
  hasCompletedOnboarding: state.hasCompletedOnboarding,
  // Exclude: isLoading, temporary UI state
}),

// ❌ Bad: Persisting everything
// (no partialize = entire state persisted)
```

### Never Persist
- Loading/processing states (`isLoading`, `isProcessing`)
- Temporary UI state
- Cached computed values
- Error states

## Action Patterns

### Use Immer-style Updates
```typescript
// ✅ Good: Return new state object
addItem: (item) => set((state) => ({
  items: [...state.items, item],
})),

// ✅ Good: Use get() for computed updates
updateTotal: () => set((state) => ({
  total: get().items.reduce((sum, i) => sum + i.value, 0),
})),
```

### Async Actions
```typescript
fetchData: async () => {
  set({ isLoading: true });
  try {
    const data = await api.getData();
    set({ data, isLoading: false });
  } catch (error) {
    set({ isLoading: false, error: error.message });
  }
},
```

## Selectors

### Use Selectors to Prevent Re-renders
```typescript
// ✅ Good: Select only needed data
const userName = useAppStore((state) => state.userName);

// ❌ Bad: Selecting entire state
const state = useAppStore();
```

### Memoized Selectors for Computed Values
```typescript
// In component
const activeItems = useAppStore(
  useCallback((state) => state.items.filter(i => i.active), [])
);
```

## Testing

### Store Reset for Tests
```typescript
// Add to store
const initialState = { /* initial values */ };

reset: () => set(initialState),
```

### Test Pattern
```typescript
import { useMyStore } from './useMyStore';

beforeEach(() => {
  useMyStore.getState().reset();
});

test('adds item', () => {
  useMyStore.getState().addItem({ id: '1', name: 'Test' });
  expect(useMyStore.getState().items).toHaveLength(1);
});
```

## Prohibited Patterns

| Prohibited | Reason | Alternative |
|------------|--------|-------------|
| Store in store | Circular dependencies | Use separate stores |
| Direct state mutation | Breaks reactivity | Use `set()` |
| `any` type in state | Type safety | Explicit interfaces |
| Persisting functions | Serialization fails | Only persist data |
| Global singleton export | Testing difficulties | Export hook only |

## Store Organization

### Single Store per Domain
```
src/stores/
  useAppStore.ts      # Core app state (user, settings)
  useAIStore.ts       # AI chat state
  useStatisticsStore.ts  # Analytics/metrics
```

### Avoid
- Mega-store with all state
- Store for single component (use useState instead)
- Multiple stores for same domain
