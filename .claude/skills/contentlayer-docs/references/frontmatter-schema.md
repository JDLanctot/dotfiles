# Contentlayer2 Frontmatter Schema

Based on `contentlayer.config.ts` PackageDoc type definition.

## Required Fields

### title
- **Type:** string
- **Required:** Yes
- **Description:** The page title displayed in navigation and on the page
- **Example:** `"Installation"`, `"Framework Overview"`

## Optional Fields

### description
- **Type:** string
- **Required:** No (but strongly recommended)
- **Description:** Brief description of the page content, used for SEO and previews
- **Example:** `"Setup and installation instructions"`

### order
- **Type:** number
- **Default:** 999
- **Description:** Controls ordering within a section. Lower numbers appear first.
- **Example:** `1`, `2`, `3`

### section
- **Type:** string
- **Default:** "General"
- **Description:** The section this page belongs to, used for grouping in navigation
- **Example:** `"Getting Started"`, `"Architecture"`, `"Configuration"`, `"Reference"`

### published
- **Type:** boolean
- **Default:** true
- **Description:** Whether this page should be visible in production
- **Example:** `true` or `false`

## Computed Fields (Automatic)

The following fields are automatically computed by Contentlayer and should NOT be included in frontmatter:

- `slug` - Automatically generated from file path
- `slugAsParams` - Automatically generated from file path
- `packageName` - Automatically extracted from file path
- `readingTime` - Automatically calculated from content length

## Example Frontmatter

```yaml
---
title: Installation
description: Setup and installation instructions
order: 2
section: Getting Started
published: true
---
```

## Determining Sections

Examine the existing `docs/docs/` directory structure to identify sections. Common patterns include:

- `"Getting Started"` - Installation, quick start, introductory guides
- `"Architecture"` - System design, core components
- `"Configuration"` - Settings, parameters, config files
- `"Development"` - Testing, commands, developer tools
- `"Reference"` - Technical references, API docs, type definitions
- `"Guides"` - How-to guides and tutorials
- `"API"` - API documentation
- `"Features"` - Feature-specific documentation
