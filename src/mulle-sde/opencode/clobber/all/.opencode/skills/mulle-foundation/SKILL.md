---
name: mulle-foundation
description: Write a non-UI mulle-objc class — model objects, utilities, data structures.
---

# Foundation Class Executor

Implement a non-UI mulle-objc class. All sub-files in `.opencode/skills/mulle-foundation/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde howto cat mulle-c-syntax    # naming conventions
mulle-sde api apropos "{class terms}"
mulle-sde code search "{similar class}"
```

Read `quirks.md` and `patterns.md` now.

## Phase 2: Design

```bash
mulle-sde api cat MulleObjC           # base ObjC runtime API
mulle-sde api cat mulle-container     # if collections needed
```

Plan:
- What data does the class hold?
- What is its memory ownership model?
- Does it need `init`/`dealloc`? (almost always yes if it holds resources)
- Does it need to conform to any protocols?

## Phase 3: Implement

```bash
mulle-sde add src/{ClassName}.m
mulle-sde reflect
```

`{ClassName}.h`:
- Only `#import "import.h"`
- Declare ivars in `@interface`, not `@implementation`
- Use `char *` for strings (named `*UTF8String`), `struct mulle_array` for collections
- No `atomic`/`weak`/`strong`, no blocks, no dot syntax

`{ClassName}.m`:
- `#import "import-private.h"`
- Prefer factory methods (`+instanceWith...`) over `alloc/init` in public API
- `dealloc`: free all owned resources, call `[super dealloc]` last

## Phase 4: Verify

```bash
mulle-sde craft
```

Fix all errors. If tests were requested as part of this task, write them now (see mulle-test patterns). Otherwise report done after clean compile.
