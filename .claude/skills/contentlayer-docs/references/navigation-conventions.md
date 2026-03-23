# Navigation and Linking Conventions

## File Organization

Documentation files are organized in `docs/docs/` with section-based subdirectories:

```
docs/
├── index.mdx (package root index with navigation)
└── docs/
    ├── section-name/
    │   ├── page-one.mdx
    │   ├── page-two.mdx
    │   └── page-three.mdx
    └── another-section/
        ├── overview.mdx
        └── details.mdx
```

## Link Format

All internal documentation links use the `/packages/{package-name}/docs/...` pattern:

```markdown
[Link Text](/packages/{package-name}/docs/section-name/page-slug)
```

### Examples

```markdown
[Installation](/packages/my-package/docs/getting-started/installation)
[Framework](/packages/my-package/docs/architecture/framework)
[API Reference](/packages/my-package/docs/reference/api)
```

## File Naming

- Use lowercase with hyphens: `quick-start.mdx`, `api-reference.mdx`
- Match the slug used in navigation links
- Be descriptive but concise

## Discovering Sections

Before creating new documentation, examine the existing `docs/docs/` directory structure to identify:

1. **Existing sections** - List subdirectories in `docs/docs/`
2. **Section naming patterns** - Check frontmatter `section` fields in existing files
3. **Ordering conventions** - Review `order` values to understand numbering scheme

## Index.mdx Structure

The root `index.mdx` serves as package metadata and navigation hub:

```markdown
---
title: PackageName
description: Brief package description
version: "1.0.0"
repository: https://github.com/user/repo
published: true
---

[Package introduction paragraph]

## Key Features

- Feature 1
- Feature 2

## Documentation

### Section Name
- [Page Title](/packages/{package-name}/docs/section/page-slug) - Description

### Another Section
- [Page Title](/packages/{package-name}/docs/section/page-slug) - Description
```

## Cross-Referencing

When referencing other documentation:

1. Use full path: `/packages/{package-name}/docs/section/page`
2. Provide meaningful link text (not "click here")
3. Add brief context when helpful

Example:
```markdown
For more details, see [Configuration Guide](/packages/my-package/docs/configuration/overview).
```

## Git Submodule Considerations

Since docs may be used as a git submodule in both the codebase and website:

1. Keep paths relative to the docs root
2. Avoid absolute URLs that might break in different contexts
3. Use the `/packages/{package-name}/docs/...` pattern consistently
4. Don't reference files outside the docs directory
