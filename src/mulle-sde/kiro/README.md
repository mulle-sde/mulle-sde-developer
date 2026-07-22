# Kiro CLI Role/Howto Adapter

This package installs a minimal `.kiro/` configuration that mirrors the
role-based howto architecture used by the opencode extension.

## What it installs

- fixed Kiro agents:
  - `orchestrator`
  - `coder`
  - `verifier`
  - `debugger`
  - `reviewer`
  - `doc-writer`
- matching role skills under `.kiro/skills/`
- one steering rule that points agents to `mulle-sde howto` for workflow/topic
  guidance and `mulle-sde api` for concrete API lookup
- default Kiro CLI settings with `orchestrator` as the default agent

## Architecture

The Kiro package does **not** carry domain topic knowledge itself.

Topic knowledge lives in repo-owned howto bundles such as:

```text
asset/howto/coder/mulle-event/index.md
asset/howto/coder/mulle-event/quirks.md
asset/howto/coder/mulle-event/patterns.md
```

Kiro agents discover and load those bundles at runtime with:

```bash
mulle-sde howto topics <role>
mulle-sde howto apropos "<task words>"
mulle-sde howto load <role> <topic>
mulle-sde api apropos "<task words>"
```

## Intended usage

After the package has been installed into a mulle-sde project and Kiro CLI is
available:

```bash
kiro-cli chat --agent orchestrator
```

The orchestrator should classify the task, infer a role/topic, and delegate to
one narrow role agent instead of embedding topic knowledge in the Kiro config.
For implementation work it should behave like the opencode orchestrator:

- discover available agents/skills first, then split work by concern
- prefer specialized agents when available; otherwise use narrow generic packets
- hand off small task packets instead of one large implementation chunk
- use one primary topic per packet and queue multiple packets when needed
- run a default implementation `coder -> verifier -> reviewer` loop per concern
- run reviewer after coder/verifier file changes to catch logic/style/simplification issues
- use `mulle-sde howto` command discovery/loading first and avoid direct
  `.mulle/share/howto` crawling
- stop only on: fully working result, clear no-progress/stuck state, or
  confirmed base-library error to report (not fix)
- prefer runtime verification for MulleUI interaction work
- point role agents toward `mulle-sde api` when concrete symbols, classes,
  methods, or installed docs matter

## Current scope

This is a first proof-of-concept adapter:

- no custom MCP servers
- no hook scripts
- no Kiro-specific topic assets

It is intentionally thin. The goal is to prove that Kiro can sit on top of the
same `mulle-sde howto` plus `mulle-sde api` runtime-discovery model.
