# Data Boundaries

Keep the atomic UI system independent from persistence and server concerns.

## Database structure in this codebase

- Schema is organized by domain under `src/server/db/schema/`.
- A single export surface in `src/server/db/schema/index.ts` re-exports tables and relations.
- DB client is initialized in `src/server/db/index.ts`.
- Query modules live in `src/server/queries/*`; actions live in `src/server/actions/*`.

## Boundary rules for UI work

- Do not import `src/server/db/*` inside generic UI atoms.
- Keep DB calls in server contexts (queries/actions/pages/server components).
- Pass prepared data into components via typed props.
- Keep shared components deterministic and side-effect minimal.

## Practical pattern

1. Fetch and validate data in server query/action layer.
2. Map to UI-friendly shape near the route/page boundary.
3. Render via `_components` (route feature) and `src/components` (shared UI).

This separation protects reusability and keeps atomic components transport-agnostic.
