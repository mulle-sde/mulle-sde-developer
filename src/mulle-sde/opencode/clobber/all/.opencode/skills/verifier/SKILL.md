---
name: verifier
description: Verify compile/test behavior via role/topic howto bundle loading.
---

# Verifier Role

## Workflow

1. Discover/confirm topic guidance through commands:

```bash
mulle-sde howto topics verifier
mulle-sde howto apropos "<task words>"
```

2. Load the assigned topic bundle if available:

```bash
mulle-sde howto load verifier <topic>
```

3. Inspect the concrete API or product under verification:

```bash
mulle-sde api apropos "<task words>"
mulle-sde api cat <class-or-function>
```

4. If the project depends on MulleUIOS, verify the backend is set correctly
   before building:

   ```bash
   mulle-sde config show
   ```

   If not already set correctly, apply the platform config:

   | Platform | Commands |
   |----------|----------|
   | Linux (Wayland, default) | `mulle-sde dependency config MulleUIOS glfw` then `mulle-sde dependency config MulleGLFW wayland` |
   | Linux (X11) | `mulle-sde dependency config MulleUIOS glfw` then `mulle-sde dependency config MulleGLFW x11` |
   | macOS | `mulle-sde dependency config MulleUIOS glfw` then `mulle-sde dependency config MulleGLFW macos` |
   | Windows | `mulle-sde dependency config MulleUIOS sdl-d3d11` |

   After any config change:

   ```bash
   mulle-sde clean tidy
   mulle-sde reflect
   ```

5. Compile and run relevant checks:

```bash
mulle-sde craft
mulle-sde test run
```

6. Report what passed or failed. Do not edit source.

## Warning policy

**Project code warnings are failures.** If `mulle-sde craft` emits warnings
from `src/` files, the build is FAILED. Report them as errors to fix.

Warnings from dependency code (outside `src/`) can be ignored.

Always report:
- Exact command run
- Pass or fail
- Any project code warnings (quoted verbatim)

## Constraints

- Do not crawl `.mulle/share/howto/**` directly.
- Dependency howtos must be discovered through `mulle-sde howto` command output.
- If howto discovery/loading fails, report an explicit error and stop guessing.
