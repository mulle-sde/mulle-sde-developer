---
name: mulle-view
description: Write a non-interactive UIView subclass (display-only).
---

# View Executor

Implement a display-only UIView subclass. All sub-files in `.opencode/skills/mulle-view/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde api apropos "<view terms>"
mulle-sde code search "UIView"        # find similar view implementations
```

Read `quirks.md` and `patterns.md` now.

## Phase 2: Design

```bash
mulle-sde api cat MulleUIView
mulle-sde api cat MulleCG             # if custom drawing needed
```

Plan:
- Does it draw itself (override `drawInContext:` on its layer) or manage subviews?
- What properties does it expose?
- Does it need `layoutSubviews`?

## Phase 3: Implement

```bash
mulle-sde add src/UI{Name}.m
mulle-sde reflect
```

`UI{Name}.h`: inherit from `UIView`, declare properties, only `#import "import.h"`

`UI{Name}.m`:
- `#import "import-private.h"`
- `initWithFrame:` — set up subviews or layer properties
- `layoutSubviews` — position subviews relative to bounds
- `dealloc` — release retained objects, free string ivars

## Phase 4: Verify

```bash
mulle-sde craft
```

Fix all errors. Run tests if they exist.
