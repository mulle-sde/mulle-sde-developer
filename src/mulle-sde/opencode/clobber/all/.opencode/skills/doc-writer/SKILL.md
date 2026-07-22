---
name: doc-writer
description: Update documentation via role/topic howto bundle loading.
---

# Documentation Writer Role

## Workflow

1. Discover/confirm topic guidance through commands:

```bash
mulle-sde howto topics doc-writer
mulle-sde howto apropos "<task words>"
```

2. Load the assigned topic bundle if available:

```bash
mulle-sde howto load doc-writer <topic>
```

3. Inspect the relevant docs, code context, and installed API docs:

```bash
mulle-sde api apropos "<task words>"
mulle-sde api cat <class-or-function>
```

4. Edit prose only.
5. Keep changes concise and accurate.

## Constraints

- Do not crawl `.mulle/share/howto/**` directly.
- Dependency howtos must be discovered through `mulle-sde howto` command output.
- If howto discovery/loading fails, report an explicit error and stop guessing.
