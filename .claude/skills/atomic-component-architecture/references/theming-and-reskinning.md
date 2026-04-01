# Theming and Reskinning

## Theme architecture

- Define light and dark tokens as CSS variables in `src/styles/globals.css` under `:root` and `.dark`.
- Map Tailwind color keys to `hsl(var(--token))` in `tailwind.config.ts`.
- Consume those semantic keys in components.

This allows global reskinning by editing token values, not component internals.

## Reskin strategy

When changing brand/theme identity:

1. Update CSS variables in `globals.css` (background, foreground, primary, accent, nav, etc).
2. Adjust Tailwind extension keys only if new semantic token categories are required.
3. Keep component class APIs stable so existing `className` overrides still function.
4. Verify both light and dark views for contrast and hierarchy.

## Component-level guardrails

- Reusable components should avoid direct hex/rgb literals.
- Prefer token-driven utility classes and controlled variants.
- Keep route-level visual experiments in `_components` unless they become global patterns.

## MDX styling note

- `src/styles/mdx.css` is part of the visual system.
- Ensure code block and prose styles remain theme compatible when token values change.
