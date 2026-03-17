---
name: mulle-layer
description: Write a CALayer or CGGraphicsLayer subclass with custom drawing.
---

# Layer Executor

Implement a rendering layer subclass. All sub-files in `.opencode/skills/mulle-layer/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide        # coding style — mandatory
mulle-sde api apropos "<layer terms>" # find relevant drawing APIs
mulle-sde code search "drawInContext" # find similar layer implementations
```

Read `quirks.md` and `patterns.md` now.

Run `mulle-sde howto list` and read any layer/drawing-related howtos available.

## Phase 2: Design

```bash
mulle-sde api cat MulleCG             # CoreGraphics drawing API
mulle-sde api cat MulleCA             # CoreAnimation layer API (if available)
```

Plan:
- What properties does the layer expose? (visual state, colors, values)
- What does `drawInContext:` need to draw?
- Does it need hit testing (`containsPoint:`)?

## Phase 3: Implement

```bash
mulle-sde add src/MulleFooLayer.m     # creates .h + .m stubs
mulle-sde reflect
```

Write `MulleFooLayer.h`:
- Inherit from `CGGraphicsLayer`
- Declare properties with primitive types and `CGColor` (no NSString, no CGPaint)
- Only `#import "import.h"` in header

Write `MulleFooLayer.m`:
- `#import "import-private.h"`
- Implement `drawInContext:` — call `[super drawInContext:context]` first
- Use `[self canvas]` for drawable bounds
- Implement property setters with `MulleObjCObjectSetDuplicatedUTF8String` for strings
- Implement `dealloc` with `MulleObjCInstanceDeallocateMemory` for string ivars

## Phase 4: Verify

```bash
mulle-sde craft
```

Fix all compiler errors before proceeding. Check `.test.ccerr` if available.

If tests exist for this layer:
```bash
mulle-sde test run test/FooLayer/
```

Read trace output to verify drawing commands are correct.
