---
applyTo: "**"
---

# Runtime howto loading

This repository uses `mulle-sde howto` as the source of truth for repo and
dependency knowledge.

Do not treat `AGENTS.md` or `.github/instructions/` as the place where domain
topic knowledge lives. Those files only define the role-based workflow.

## Discovery

When you need project-specific guidance:

```bash
mulle-sde howto roles
mulle-sde howto topics <role>
mulle-sde howto apropos "<task words>"
```

When you have identified the closest topic:

```bash
mulle-sde howto load <role> <topic>
```

## Working model

- classify by role first: `coder`, `verifier`, `debugger`, `doc-writer`
- keep context narrow: one role, one topic, one task packet
- use `mulle-sde api` and `mulle-sde code` for API/source discovery
- do not invent project conventions that are already expressed in howtos
