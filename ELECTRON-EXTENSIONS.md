# mulle-sde Electron/JavaScript Extensions

This document describes the new mulle-sde extensions for JavaScript and Electron development.

## Extension Structure

We created a hierarchical extension system for JavaScript/Electron projects:

```
electron-developer (meta)
  └── js-developer (meta)
       ├── js (runtime)
       ├── npm (buildtool)
       ├── github-actions (extra)
       └── vscode (extra)
  └── electron (extra)
```

## Extensions Created

### 1. js (runtime)
**Location:** `src/mulle-sde/js/`
**Type:** runtime
**Purpose:** Provides JavaScript runtime environment

**Files:**
- `type`: runtime
- `language`: javascript
- `tool`: node, npm
- `environment`: Sets PROJECT_LANGUAGE='javascript', PROJECT_EXTENSIONS='js'
- `version`: 0.1.0

### 2. npm (buildtool)
**Location:** `src/mulle-sde/npm/`
**Type:** buildtool
**Purpose:** npm package manager and build system

**Files:**
- `type`: buildtool
- `tool`: npm
- `version`: 0.1.0

**Templates:**
- `project/all/package.json`: Basic npm package.json with repository field (required for npm provenance)
- `project/all/.gitignore`: Standard Node.js gitignore
- `demo/all/README.md`: Basic README template
- `demo/all/index.js`: Hello world demo

### 3. js-developer (meta)
**Location:** `src/mulle-sde/js-developer/`
**Type:** meta
**Purpose:** Combines JavaScript runtime with npm buildtool and extras

**Inherits:**
- `mulle-sde/js;runtime`
- `mulle-sde/npm;buildtool`
- `mulle-sde/github-actions;extra`
- `mulle-sde/vscode;extra`

### 4. electron (extra)
**Location:** `src/mulle-sde/electron/`
**Type:** extra
**Purpose:** Adds Electron-specific files and configuration

**Files:**
- `type`: extra
- `tool`: electron, electron-builder
- `version`: 0.1.0

**Templates (clobber):**
- `clobber/all/package.json`: Full Electron package.json with:
  - electron and electron-builder in devDependencies (NOT dependencies!)
  - bin entry for CLI usage
  - Scripts for building all platforms
  - electron-builder configuration with GitHub publishing
  - Repository field for npm provenance validation

**Templates (demo):**
- `demo/all/cli.js`: CLI launcher for npx usage
- `demo/all/main.js`: Electron main process
- `demo/all/preload.js`: Preload script with contextBridge
- `demo/all/index.html`: Main HTML file
- `demo/all/renderer.js`: Renderer process code
- `demo/all/styles.css`: Basic styles

### 5. electron-developer (meta)
**Location:** `src/mulle-sde/electron-developer/`
**Type:** meta
**Purpose:** Complete Electron development setup

**Inherits:**
- `mulle-sde/js-developer;meta`
- `mulle-sde/electron;extra`

## Usage

### Create a new Electron project:

```bash
mulle-sde init -m mulle-sde/electron-developer -d my-electron-app executable
cd my-electron-app
```

This will create a project with:
- Complete Electron application structure
- package.json configured for npm publishing with provenance
- GitHub Actions support (if github-actions extension is available)
- VSCode configuration (if vscode extension is available)
- All necessary demo files to get started

### Create a basic JavaScript/Node.js project:

```bash
mulle-sde init -m mulle-sde/js-developer -d my-node-app executable
cd my-node-app
```

## Key Features

### npm Provenance Support
The package.json templates include the `repository` field, which is **required** for npm's OIDC Trusted Publishing. Without this field, publishing from GitHub Actions will fail with:

```
Error verifying sigstore provenance bundle: Failed to validate repository information
```

### Electron Best Practices
- electron in devDependencies (not dependencies) - required by electron-builder
- Proper security with contextIsolation and nodeIntegration: false
- CLI support via bin entry
- Multi-platform builds configured
- GitHub Releases publishing configured

### Template Expansion
All files support mulle-sde template expansion with keywords like:
- `<|PROJECT_NAME|>`: Project name
- `<|PROJECT_DOWNCASE_IDENTIFIER|>`: Lowercase identifier (for npm package names)
- `<|AUTHOR|>`: Author from environment
- `<|ORGANIZATION|>`: Organization from environment
- `<|YEAR|>`: Current year

## Integration with GitHub Actions

When combined with the github-actions extension, projects get automatic:
- Multi-platform binary builds (Linux, macOS, Windows)
- GitHub Releases with binary uploads
- npm publishing with OIDC (no tokens needed)

Required workflow permissions:
```yaml
permissions:
  contents: write      # For creating GitHub releases
  id-token: write      # For npm OIDC publishing
```

## Extension Development Notes

### Clobber vs Project vs Demo
- **clobber**: Files that overwrite existing files during upgrades (use sparingly!)
- **project**: Essential files that won't be overwritten during upgrades
- **demo**: Example files that are only installed once, never upgraded

### Meta Extension Inheritance
Meta extensions can inherit from other meta extensions by specifying the type:
```
mulle-sde/js-developer;meta
```

### Tool Specification
Tools can be marked as optional:
```
node;optional
npm
```

## Testing the Extensions

1. Make sure mulle-sde-developer is installed/updated
2. Create a test project:
   ```bash
   mulle-sde init -m mulle-sde/electron-developer -d test-electron executable
   ```
3. Verify all files are created correctly
4. Test the application:
   ```bash
   cd test-electron
   npm install
   npm start
   ```

## Future Enhancements

Potential additions:
- TypeScript support (ts-developer meta extension)
- React/Vue/Angular oneshot extensions for adding components
- Testing framework integration (Jest, Mocha)
- Linting/formatting (ESLint, Prettier) as extra extensions
- Docker support
- More sophisticated GitHub Actions workflows
