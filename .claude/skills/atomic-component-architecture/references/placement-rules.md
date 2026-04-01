# Placement Rules

Use this decision flow before creating a component.

1. Is it a low-level visual primitive (button, input, popover, layout shell piece)?
   - Yes -> `src/components/ui/`
2. Is it reusable across multiple route groups or product areas?
   - Yes -> `src/components/<domain>/` or `src/components/`
3. Is it large and mostly useful to one route subtree (2-5 related routes)?
   - Yes -> `src/app/<group>/<path>/_components/`
4. Is it only used by one page and unlikely to spread?
   - Keep route-local in that page's `_components`.

## Promotion rule

- Keep components route-local first.
- Promote to `src/components` when:
  - A second route/group needs it, or
  - The component has become a clear design-system element.

## Naming guidance

- Use descriptive, behavior-first names: `team-view-switch.tsx`, `post-card.tsx`, `resume-deck.tsx`.
- Keep primitive names generic (`button.tsx`, `dialog.tsx`).
- Keep route-scoped names explicit to avoid false global reuse.

## Import guidance

- Cross-app shared imports: `@/components/...`
- Route-local imports: relative paths or alias to route `_components`.
- Prefer shortest clear path without hiding layer boundaries.
