# Documentation Structure Conventions

This file describes the standard directory structure and organization patterns for SolidJS + SST project documentation.

## Standard Directory Structure

```
docs/{project-name}/
├── GETTING_STARTED.md          # Entry point, navigation guide
├── IMPLEMENTATION_STATUS.md    # Feature status tracking (optional)
├── layers/                     # Technical layer documentation
│   ├── BACKEND.md             # Backend API, database, endpoints
│   ├── FRONTEND.md            # SolidJS app structure
│   ├── AUTH.md                # Authentication system
│   ├── INFRASTRUCTURE.md      # SST, AWS resources
│   └── [OTHER_LAYERS].md      # Additional services (CHAT, PAYMENTS, etc.)
├── features/                   # Feature domain documentation
│   ├── [FEATURE_1].md
│   ├── [FEATURE_2].md
│   └── ...
├── setup/                      # Initial setup guides
│   ├── BACKEND_SETUP.md
│   ├── SECRETS_SETUP.md
│   └── [SERVICE]_SETUP.md
├── deployment/                 # Operations and deployment
│   ├── DEPLOYMENT.md
│   ├── CICD_GUIDE.md
│   └── MONITORING.md
├── security/                   # Security documentation
│   └── SECURITY_*.md
└── architecture/               # System architecture
    └── SYSTEM_ARCHITECTURE.md
```

## Documentation Categories

### 1. layers/ - Technical Layer Documentation

**Purpose**: Describe technology stack, setup, and implementation details for each architectural layer.

**Content Guidelines**:
- Technology stack and dependencies
- Setup instructions and configuration
- File structure and organization
- API surface or component library
- Development workflow

**What NOT to include**:
- Business logic or feature requirements (use features/ instead)
- Duplicate content from other docs (cross-reference instead)

### 2. features/ - Feature Domain Documentation

**Purpose**: Describe business logic and domain models, technology-agnostic.

**Content Guidelines**:
- Domain models and entities
- Business rules and validation
- User flows and workflows
- API endpoints (what they do, not implementation)
- Database schema (what exists, not setup)

**What NOT to include**:
- Technology stack details (use layers/ instead)
- Setup instructions (use setup/ instead)
- Code examples (reference layer docs instead)

### 3. setup/ - Initial Setup Guides

**Purpose**: Step-by-step instructions for environment setup.

**Content**:
- Service configuration (databases, Redis, AWS, etc.)
- Secrets and environment variables
- Local development setup

### 4. deployment/ - Operations Documentation

**Purpose**: Production deployment and monitoring.

**Content**:
- Deployment procedures
- CI/CD configuration
- Monitoring and alerting
- CORS and infrastructure configuration

### 5. security/ - Security Documentation

**Purpose**: Security requirements and implementation.

**Content**:
- Security audits and findings
- Implementation checklists
- Compliance requirements

### 6. architecture/ - System Architecture

**Purpose**: Overall system design and architectural decisions.

**Content**:
- System diagrams
- Component relationships
- Design decisions and trade-offs

## File Naming Conventions

- Use UPPERCASE for all markdown files: `FEATURE_NAME.md`
- Use underscores for multi-word names: `CALENDAR_SYNC.md`
- Layer files match their layer name: `BACKEND.md`, `FRONTEND.md`
- Setup files end with `_SETUP`: `SECRETS_SETUP.md`
- Guides end with `_GUIDE`: `CICD_GUIDE.md`

## Cross-Referencing Pattern

Use relative paths with backticks:

```markdown
See `layers/BACKEND.md` for API implementation
See `features/DOCUMENTS.md` for business logic
See `setup/SECRETS_SETUP.md` for configuration
```

## GETTING_STARTED.md Structure

The GETTING_STARTED.md file serves as the documentation hub:

1. **Recent Updates** section at the top
2. **Documentation Structure** - Describe each category
3. **Quick Start** - Onboarding paths for different roles
4. **Documentation Principles** - Explain what goes where
5. **Cross-References** - Show referencing patterns
6. **Common Scenarios** - Link common tasks to relevant docs
7. **Documentation TODOs** - Track incomplete documentation

## Version Tracking

- Include "Last Updated" date at the bottom of each file
- Reference specific line numbers when pointing to code: `file.go:123`
- Use emoji markers for recent updates: ✅ **NEW**, ✅ **UPDATED**

## Git Submodule Pattern

Documentation is typically a git submodule shared between:
- Main codebase (for LLM context in any package)
- Frontend compilation (for website documentation pages)

**Important**:
- Keep paths relative to docs root
- Don't reference files outside docs directory
- Maintain standalone documentation that works in both contexts
- The `docs/` directory itself may contain other markdown files (scratch area)
- The `docs/{project-name}/` subdirectory is the submodule root
