---
name: coder
description: Implement code changes via role/topic howto bundle loading.
---

# Coder Role

## Workflow

1. Discover/confirm topic guidance through commands:

```bash
mulle-sde howto topics coder
mulle-sde howto apropos "<task words>"
```

2. Load the assigned topic bundle:

```bash
mulle-sde howto load coder <topic>
```

3. Inspect concrete APIs and examples:

```bash
mulle-sde api apropos "<task words>"
mulle-sde api cat <class-or-function>
```

4. If the project depends on MulleUIOS, set the backend before building:

   Check current config first:

   ```bash
   mulle-sde config show
   ```

   If not already set correctly, apply the platform config and rebuild:

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

5. Edit code.
6. Compile with `mulle-sde craft`.
7. Report result.

## Constraints

- Do not crawl `.mulle/share/howto/**` directly.
- Dependency howtos must be discovered through `mulle-sde howto` command output.
- If howto discovery/loading fails, report an explicit error and stop guessing.
