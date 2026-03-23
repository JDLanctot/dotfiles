---
name: contentlayer-docs
description: Create and maintain Contentlayer2 MDX documentation for React-based projects with contentlayer.config.ts. Use when working in projects with Contentlayer2 setup (look for contentlayer.config.ts file) for creating new documentation pages, updating existing docs, reorganizing documentation structure, maintaining index.mdx navigation, or ensuring frontmatter consistency with Contentlayer PackageDoc schema (title, description, order, section, published). Do NOT use for SolidJS or other non-Contentlayer documentation projects.
---

# Contentlayer2 Documentation Management

Create and maintain Contentlayer2 MDX documentation that works as a git submodule for both codebase reference and website compilation.

## Before Starting

1. **Verify this is a Contentlayer2 project** - Check for `contentlayer.config.ts` in the docs directory. If not present, this skill should not be used.
2. **Identify the package name** by examining the existing `docs/index.mdx` or `docs/contentlayer.config.ts`
3. **Survey existing structure** - List `docs/docs/` subdirectories to understand current sections
4. **Review patterns** - Read 2-3 existing MDX files to understand frontmatter and style conventions

## Creating New Documentation

### Step 1: Choose the Right Template

Use templates from the `assets/` directory:

- **`template-guide.mdx`** - General documentation pages, how-to guides, concept explanations
- **`template-reference.mdx`** - API references, technical specifications, type definitions
- **`template-overview.mdx`** - Section overview pages (usually `order: 1` in a section)

### Step 2: Fill in Frontmatter

See [frontmatter-schema.md](references/frontmatter-schema.md) for complete field reference.

Required fields:
```yaml
---
title: Page Title
description: Brief description of content
order: 1
section: Section Name
published: true
---
```

**Important:**
- Check existing files in the target section to determine the next `order` number
- Use the exact `section` name from existing files in that section (case-sensitive)
- Lower `order` values appear first in navigation

### Step 3: Write Content

- Use clear heading hierarchy (##, ###)
- Include code examples with language tags
- Cross-reference related pages using proper link format
- See [navigation-conventions.md](references/navigation-conventions.md) for linking patterns

### Step 4: Create the File

Place the file in the appropriate section directory:
```
docs/docs/{section-name}/{page-slug}.mdx
```

## Updating Existing Documentation

1. Read the file first to understand current structure
2. Preserve frontmatter fields unless explicitly changing them
3. Maintain the existing heading hierarchy
4. Update cross-references if file structure changes

## Updating index.mdx Navigation

When adding new documentation pages, update `docs/index.mdx`:

1. Find the appropriate section in the documentation list
2. Add the new page link following the established pattern:
   ```markdown
   - [Page Title](/packages/{package-name}/docs/section/page-slug) - Brief description
   ```
3. Maintain alphabetical or logical ordering within sections
4. Ensure the link path matches the file location

## Reorganizing Documentation

When moving or restructuring documentation:

1. **Update file locations** - Move MDX files to new directories
2. **Update frontmatter** - Change `section` field if moving to a different section
3. **Update links** - Search for references to moved pages and update paths
4. **Update index.mdx** - Reflect new structure in navigation
5. **Verify** - Check that all cross-references still work

## Common Workflows

### Adding a New Section

1. Create directory: `docs/docs/{new-section}/`
2. Create overview page: `docs/docs/{new-section}/overview.mdx` with `order: 1`
3. Add section to `docs/index.mdx` with links to pages
4. Create additional pages with incremental `order` values

### Adding to Existing Section

1. Review existing pages in the section to understand numbering
2. Choose appropriate `order` value (typically max + 1)
3. Use matching `section` name from existing files
4. Add link to `docs/index.mdx` in the appropriate section

### Ensuring Consistency

Before finalizing changes:

1. Check frontmatter matches schema
2. Verify all links use `/packages/{package-name}/docs/...` format
3. Confirm `section` names match existing conventions
4. Ensure `order` values are sequential and logical

## Package Name Discovery

The package name appears in link paths. Find it by:
- Reading `docs/index.mdx` frontmatter (look for repository or title)
- Checking existing page links in `docs/index.mdx`
- Examining `docs/contentlayer.config.ts` for context

## Git Submodule Considerations

Documentation lives in a git submodule used by both:
- The main codebase (for LLM context)
- A documentation website (for public consumption)

Therefore:
- Keep all paths relative to the `docs/` root
- Use the `/packages/{package-name}/docs/...` pattern consistently
- Don't reference files outside the `docs/` directory
- Maintain clear, standalone documentation that works in both contexts
