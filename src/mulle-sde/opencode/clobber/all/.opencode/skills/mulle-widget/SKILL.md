---
name: mulle-widget
description: Write a UIControl subclass with its rendering layer and event wiring.
---

# Widget Executor

Implement a complete interactive widget: layer + view + event handling. 
All sub-files in `.opencode/skills/mulle-widget/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde api apropos "<widget terms>"
mulle-sde code search "UIControl"     # find similar widget implementations
```

Read `quirks.md` and `patterns.md` now.

Run `mulle-sde howto list` and read any widget-related howtos available.

## Phase 2: Design

```bash
mulle-sde api cat MulleUIView         # UIView/UIControl API
mulle-sde api cat MulleCG             # drawing API for the layer
```

Plan:
- Layer class name: `Mulle{Name}Layer` — owns drawing, visual properties
- View class name: `UI{Name}` — owns public API, events, forwards to layer
- What states does the control have? (normal, highlighted, selected, disabled)
- What events does it handle? (mouseDown, mouseUp, mouseDragged)
- What does it emit via target-action?

## Phase 3: Implement

Ensure we have the proper dependency:

```bash
mulle-sde dependency add github:MulleUI/MulleUIWidget
```

``` bash
mulle-sde add src/Mulle{Name}Layer.m
mulle-sde add src/UI{Name}.m
mulle-sde reflect
```

Write layer first (see mulle-layer patterns). Then write the view:

`UI{Name}.h`:
- Inherit from `UIControl`
- Declare public properties (forwarded to layer)
- Only `#import "import.h"`

`UI{Name}.m`:
- `#import "import-private.h"`
- `initWithFrame:` — create and attach layer
- Property setters forward to `[[self layer] setFoo:foo]`
- Event handlers return `UIInputEvent *`, call super
- `didAcceptEvent:` triggers `setNeedsDisplay` after state change

## Phase 4: Verify

```bash
mulle-sde craft
```

Fix all errors. Then if tests exist:
```bash
mulle-sde test run test/UI{Name}/
```

Verify state transitions via trace output and golden file comparison.
