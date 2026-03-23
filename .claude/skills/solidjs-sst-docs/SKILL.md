---
name: solidjs-sst-docs
description: Create and maintain markdown documentation for SolidJS applications with SST (Serverless Stack). Use when working on SolidJS + SST projects for creating new documentation pages, updating existing docs, organizing documentation structure, or maintaining GETTING_STARTED.md navigation. Structured for git submodule use where docs are available in codebase (for LLM context) and compiled by frontend (for documentation pages). Do NOT use for React/Contentlayer2 projects (use contentlayer-docs instead) or projects without the docs/{project-name}/ structure.
---

# SolidJS + SST Documentation Management

Create and maintain structured markdown documentation for SolidJS applications built with SST (Serverless Stack). Documentation follows a layered architecture pattern and serves as a git submodule for both codebase reference and frontend compilation.

## Before Starting

1. **Verify project structure** - Check for `docs/{project-name}/` directory. The `docs/` folder itself is a scratch area; `docs/{project-name}/` is the documentation root (git submodule).
2. **Identify the project** - Look at existing `docs/{project-name}/GETTING_STARTED.md` to understand project name and structure.
3. **Survey existing structure** - List subdirectories (`layers/`, `features/`, `setup/`, etc.) to understand current organization.
4. **Review patterns** - Read 2-3 existing markdown files to understand style and conventions.

## Documentation Structure

See [structure-conventions.md](references/structure-conventions.md) for complete details.

### Standard Categories

- **layers/** - Technical layer documentation (BACKEND.md, FRONTEND.md, AUTH.md, INFRASTRUCTURE.md)
- **features/** - Feature domain documentation (business logic, entities, flows)
- **setup/** - Initial setup guides (service configuration, secrets)
- **deployment/** - Operations documentation (deployment, CI/CD, monitoring)
- **security/** - Security requirements and implementation
- **architecture/** - System architecture and design decisions

## Creating New Documentation

### Step 1: Choose the Right Template

Use templates from the `assets/` directory:

- **`template-layer.md`** - Technical layer docs (backend, frontend, auth, etc.)
- **`template-feature.md`** - Feature domain docs (business logic, entities)
- **`template-setup.md`** - Setup and configuration guides
- **`template-architecture.md`** - Architecture and system design docs

### Step 2: Determine File Location

Place the file in the appropriate category directory:

```
docs/{project-name}/{category}/{FILE_NAME}.md
```

**Naming convention**: Use UPPERCASE with underscores: `CALENDAR_SYNC.md`, `BACKEND_SETUP.md`

### Step 3: Fill in Content

1. Copy the appropriate template
2. Replace all `[placeholder]` sections with actual content
3. Remove sections that don't apply
4. Add cross-references to related documentation
5. Add "Last Updated" date at the bottom

### Step 4: Update GETTING_STARTED.md

When adding significant new documentation, update `GETTING_STARTED.md`:

1. Add the file to the appropriate category section
2. Update cross-reference examples if needed
3. Add to "Common Scenarios" if it addresses a frequent task
4. Update "Recent Updates" section at the top

## Updating Existing Documentation

1. Read the file first to understand current structure
2. Maintain the existing heading hierarchy
3. Update "Last Updated" date at the bottom
4. Update cross-references if file structure changes
5. Mark significant updates with ✅ **UPDATED** emoji in relevant files

## Layer vs Feature Documentation

### Layer Docs (layers/)

**Focus**: How the technology works

**Contents**:
- Technology stack and dependencies
- Setup instructions and configuration
- File structure and organization
- API surface or component library
- Development workflow

**Example sections**:
- "Project Structure"
- "Setup"
- "API Endpoints" (implementation focused)
- "Development Workflow"

### Feature Docs (features/)

**Focus**: What the business logic does

**Contents**:
- Domain models and entities
- Business rules and validation
- User flows and workflows
- API endpoints (business logic focused)
- Database schema (entities and relationships)

**Example sections**:
- "Core Entities"
- "Business Rules"
- "User Flows"
- "API Endpoints" (what they do, not implementation)

**Key principle**: Feature docs should be technology-agnostic. They describe WHAT, not HOW.

## Cross-Referencing

Use relative paths with backticks:

```markdown
See `layers/BACKEND.md` for API implementation details
See `features/DOCUMENTS.md` for document business logic
See `setup/SECRETS_SETUP.md` for environment configuration
```

**From layer docs to features**:
```markdown
See `features/CALENDAR_SYNC.md` for sync business rules
```

**From feature docs to layers**:
```markdown
See `layers/BACKEND.md` for endpoint implementation
See `layers/FRONTEND.md` for UI components
```

## Code References

When referencing specific code locations, use the pattern:
```markdown
File: `path/to/file.ext` (line XX-YY)
File: `packages/backend/internal/handlers/users.go:455`
```

## Common Workflows

### Adding a New Layer

1. Create `docs/{project-name}/layers/{LAYER_NAME}.md` using `template-layer.md`
2. Fill in technology stack, structure, setup, API, and workflow sections
3. Add cross-references to related features
4. Update `GETTING_STARTED.md` layers section

### Adding a New Feature

1. Create `docs/{project-name}/features/{FEATURE_NAME}.md` using `template-feature.md`
2. Document entities, business rules, user flows, and API endpoints (business logic view)
3. Add cross-references to implementation layers
4. Update `GETTING_STARTED.md` features section

### Adding a Setup Guide

1. Create `docs/{project-name}/setup/{SERVICE}_SETUP.md` using `template-setup.md`
2. Provide step-by-step setup instructions
3. Include verification steps and troubleshooting
4. Update `GETTING_STARTED.md` setup section

### Creating IMPLEMENTATION_STATUS.md (Optional)

For active projects, create a status tracking document:
- List features with status: ✅ Fully Implemented, ⚠️ Partially Implemented, ❌ Not Implemented
- Track recent completions with dates
- Reference code locations for each feature
- List environment variables required
- Track next sprint priorities

See the Legal Locker project for an example pattern.

### Updating GETTING_STARTED.md

When reorganizing or adding significant documentation:

1. Update "Recent Updates" section with date
2. Add/modify category descriptions
3. Update "Common Scenarios" with new use cases
4. Update cross-reference examples
5. Update "Documentation TODOs" if gaps exist

## File Naming Conventions

- **Layers**: `BACKEND.md`, `FRONTEND.md`, `AUTH.md`, `INFRASTRUCTURE.md`
- **Features**: `{FEATURE_NAME}.md` (e.g., `DOCUMENTS.md`, `CALENDAR_SYNC.md`)
- **Setup**: `{SERVICE}_SETUP.md` (e.g., `BACKEND_SETUP.md`, `SECRETS_SETUP.md`)
- **Deployment**: `DEPLOYMENT.md`, `CICD_GUIDE.md`, `MONITORING.md`
- **Architecture**: `SYSTEM_ARCHITECTURE.md`, `{TOPIC}_SYSTEM.md`

Always use UPPERCASE with underscores for multi-word names.

## Version Tracking

Include at the bottom of each file:

```markdown
---

**Last Updated**: YYYY-MM-DD
```

For recent changes, mark sections with:
```markdown
✅ **NEW** - Recently added
✅ **UPDATED** - Recently updated
```

## Git Submodule Considerations

Documentation lives in a git submodule at `docs/{project-name}/`:

**Purpose**:
- Available in main codebase for LLM context when working on any package
- Compiled by frontend for documentation website pages

**Important**:
- Keep all paths relative to `docs/{project-name}/` root
- Don't reference files outside the documentation directory
- Maintain standalone documentation that works in both contexts
- The `docs/` directory itself may contain other markdown files (scratch area)

## Best Practices

1. **Avoid duplication** - Use cross-references instead of copying content
2. **Keep layer docs technical** - Setup, API surface, file structure
3. **Keep feature docs business-focused** - What it does, not how it's implemented
4. **Update dates** - Always update "Last Updated" when editing
5. **Reference code locations** - Use `file.ext:line` pattern for precision
6. **Maintain templates** - Don't deviate from template structure without reason
7. **Update GETTING_STARTED.md** - Keep it as the single source of navigation truth
