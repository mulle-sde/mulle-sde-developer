# Runtime howto and API loading

Use `mulle-sde howto` for workflow/topic knowledge and `mulle-sde api` for
concrete API lookup.

Command-first policy: use `mulle-sde howto` commands for discovery and loading.
Do not crawl `.mulle/share/howto` (or dependency howto folders) directly.

Do not treat `.kiro/agents/`, `.kiro/skills/`, or steering files as the place
where domain topic knowledge lives. Those files only define fixed role behavior.

## Discovery rules

When you need project-specific guidance:

```bash
mulle-sde howto roles
mulle-sde howto topics <role>
mulle-sde howto apropos "<task words>"
mulle-sde api apropos "<task words>"
```

When you have identified the closest topic:

```bash
mulle-sde howto load <role> <topic>
```

When you need concrete classes, methods, functions, or installed docs:

```bash
mulle-sde api apropos "<symbol or task words>"
mulle-sde api cat <name>
```

## Constraints

- Prefer one role and one topic at a time.
- Do not try to absorb all howtos at once.
- Dependency-provided howtos must be discovered through `mulle-sde howto`
  commands, not by direct filesystem scans.
- After choosing a topic, use `mulle-sde api` to inspect the concrete symbols
  that implement the task.
- If a howto command fails, emit an explicit error and stop guessing.
- Keep the Kiro configuration thin; durable topic knowledge belongs in
  `asset/howto/<role>/<topic>/...` and installed `share/howto/...`.
