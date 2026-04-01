---
name: atomic-component-architecture
description: Maintain an atomic Next.js and Tailwind component system with shared primitives in src/components, route-scoped feature components in src/app/**/_components, and CSS-variable driven light/dark theming through cn() class merging. Use when adding or refactoring UI, deciding component placement, enforcing reusable design patterns, or preventing style drift while enabling easy reskinning.
---

# Atomic Component Architecture

Use this workflow to keep UI changes modular, reusable, and easy to reskin.

1. Classify the requested UI change.
2. Place components at the correct layer.
3. Implement style APIs that preserve override freedom.
4. Keep data and DB access outside atomic UI layers.
5. Verify architecture and theming constraints before finishing.

## 1) Classify the change

- Decide if the change is an atom/molecule/organism used broadly, or a route-scoped feature block.
- Read `references/placement-rules.md` before creating new files.
- If uncertain, start route-local in `_components` and promote to `src/components` only after second reuse or clear cross-route demand.

## 2) Place files intentionally

- Use `src/components/ui/*` for low-level primitives and shadcn-style building blocks.
- Use `src/components/*` (non-ui folders) for cross-route domain components that are still broadly reusable.
- Use `src/app/<route-group>/**/_components/*` for larger route-scoped sections shared by only a few nearby routes.
- Keep route pages thin: orchestration and data fetch in page/layout files, rendering in components.

Read `references/structure-map.md` for canonical locations and `references/data-boundaries.md` for server/data boundaries.

## 3) Preserve reskin and override flexibility

- Always expose `className` on reusable visual components.
- Merge classes with `cn()` from `src/lib/utils.ts`; never concatenate class strings manually.
- Use semantic Tailwind tokens (`bg-background`, `text-foreground`, `border-border`, `text-muted-foreground`) instead of hardcoded color values.
- Use component variants (`class-variance-authority`) when a component needs consistent variant/size APIs.
- Keep theme source of truth in CSS variables and Tailwind token mapping, not per-component literal palette values.

Read `references/authoring-patterns.md` and `references/theming-and-reskinning.md` before introducing new style APIs.

## 4) Keep DB and server logic out of atomic components

- Do not import DB schema/query/action modules into shared UI atoms.
- Fetch data in server routes/actions/queries, then pass typed props into components.
- Keep `src/components` focused on view composition, interactions, and visual variants.
- Allow route-level `_components` to compose feature UI using prepared data, but keep direct DB concerns in server layers.

## 5) Verify before completion

For each UI change, confirm:

- Placement: component is in the right layer (`src/components` vs route `_components`).
- Styling: uses `cn()` and supports `className` overrides where reuse is expected.
- Theme: uses semantic tokens compatible with `.dark` variable overrides.
- Boundaries: no accidental DB/data-layer coupling inside atomic UI primitives.

## Output format for architectural decisions

When you make architectural choices, report them briefly in this shape:

- `Placement`: why file location was chosen.
- `Reuse Strategy`: promote now or keep route-local.
- `Theme Strategy`: tokens/variables used and how overrides work.
- `Boundary Check`: where data is fetched and where UI is rendered.

## External pattern notes

- Adopt external patterns only when they fit this architecture's layering, theming tokens, and class override model.
- Do not assume any project-specific reference folder exists in the target codebase.
