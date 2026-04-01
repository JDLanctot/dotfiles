# Authoring Patterns

## Class merge contract

- Always accept `className?: string` on reusable visual components.
- Use `cn()` from `@/lib/utils` to merge defaults with overrides.
- Keep defaults first, user overrides last through `cn(base, className)` or `cn(variantFn(...), className)`.

## Variant contract

Use `class-variance-authority` when variants must stay consistent:

```tsx
const componentVariants = cva("base classes", {
  variants: {
    variant: { default: "...", outline: "..." },
    size: { sm: "...", md: "..." },
  },
  defaultVariants: { variant: "default", size: "md" },
})
```

Then merge with `cn(componentVariants({ variant, size, className }))`.

## Token-first styling

- Prefer semantic classes over fixed color values.
- Good: `bg-background`, `text-foreground`, `border-border`, `text-muted-foreground`.
- Avoid locking reusable components to route-specific visual motifs unless intentionally specialized.

## Route feature composition

- In `_components`, build larger composed sections by combining shared primitives and domain components.
- Keep route feature files focused on UX flow and presentation assembly.
- Push generic logic downward only after repeated reuse appears.
