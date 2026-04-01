# Structure Map

## Core files this skill assumes

- `src/components/`: reusable UI and domain components.
- `src/components/ui/`: low-level primitives and variant-driven building blocks.
- `src/app/**/_components/`: route-scoped larger components shared by nearby routes.
- `src/lib/utils.ts`: `cn(...inputs)` via `clsx` + `tailwind-merge`.
- `tailwind.config.ts`: semantic token mapping from classes to CSS variables.
- `src/styles/globals.css`: light/dark variable definitions and global component utility classes.
- `src/styles/mdx.css`: markdown/codeblock styling layer that still relies on theme context.
- `package.json`: dependencies enabling this pattern (`class-variance-authority`, `clsx`, `tailwind-merge`, `next-themes`, Tailwind tooling, Radix/shadcn ecosystem packages).

## Expected layering

- Primitive layer: small generic parts (`Button`, `Input`, `Card`, `Dialog`, etc).
- Shared composite layer: reusable domain widgets (`data-table/*`, comments, content blocks, shells).
- Route feature layer: `_components` for route-group specific sections.
- Page/layout layer: routing concerns, data orchestration, metadata, and composition.

Keep dependencies flowing inward:

- Route pages -> route `_components` and shared components
- Shared components -> primitives/utilities
- Primitives -> utility helpers

Avoid inverse dependencies (primitives importing route-level files).
