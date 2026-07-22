# GitHub Copilot CLI Role/Howto Adapter

This package installs a minimal instruction setup for GitHub Copilot CLI that
mirrors the role-based howto architecture used by the opencode and Kiro
adapters.

## What it installs

- `AGENTS.md` with the default orchestration workflow
- one global `.github/instructions/*.instructions.md` file that states the
  runtime howto model

## Architecture

The Copilot adapter does **not** carry domain topic knowledge itself.

Topic knowledge lives in repo-owned howto bundles such as:

```text
asset/howto/coder/mulle-event/index.md
asset/howto/coder/mulle-event/quirks.md
asset/howto/coder/mulle-event/patterns.md
```

Copilot should discover and load those bundles at runtime with:

```bash
mulle-sde howto roles
mulle-sde howto topics <role>
mulle-sde howto apropos "<task words>"
mulle-sde howto load <role> <topic>
```

## Intended usage

Open GitHub Copilot CLI in a project that has this package installed.

Copilot will pick up:

- `AGENTS.md`
- `.github/instructions/**/*.instructions.md`

from the repository, and should follow the fixed-role runtime-loading model:

- orchestrate by role first
- infer a topic
- load exactly one relevant howto bundle
- then perform the task in that lane

## Current scope

This is a first proof-of-concept adapter:

- no custom Copilot subagent definitions
- no Copilot skill packaging
- no topic knowledge duplicated into Copilot-specific files

It is intentionally thin. The goal is to prove that Copilot CLI can sit on top
of the same `mulle-sde howto` runtime-loading model.
