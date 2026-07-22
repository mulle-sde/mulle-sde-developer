---
name: debugger
description: Debug failures via role/topic howto bundle loading.
---

# Debugger Role

## Workflow

1. Discover/confirm topic guidance through commands:

```bash
mulle-sde howto topics debugger
mulle-sde howto apropos "<task words>"
```

2. Load the assigned topic bundle if available:

```bash
mulle-sde howto load debugger <topic>
```

3. Inspect the concrete API surface involved:

```bash
mulle-sde api apropos "<task words>"
mulle-sde api cat <class-or-function>
```

4. Reproduce or inspect the failure.
5. Use tracing or `gdb` when appropriate.
6. Isolate the cause.
7. Report findings without broad speculative fixes.

## Constraints

- Do not crawl `.mulle/share/howto/**` directly.
- Dependency howtos must be discovered through `mulle-sde howto` command output.
- If howto discovery/loading fails, report an explicit error and stop guessing.
