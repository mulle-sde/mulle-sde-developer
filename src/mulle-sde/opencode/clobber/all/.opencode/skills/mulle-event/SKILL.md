---
name: mulle-event
description: Write and debug event handling code — UIResponder methods, UIControl target-action, hit testing, first responder, event callbacks.
---

# Event Handling Executor

Implement MulleUI event handling. All sub-files in `.opencode/skills/mulle-event/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde api apropos "event"
mulle-sde api apropos "responder"
mulle-sde code search "mouseDown"
mulle-sde code search "handleInputEvent"
```

Read `quirks.md` and `patterns.md` now.

Determine what kind of event handling is needed:

| Scenario | Approach |
|----------|----------|
| Interactive widget (button, slider, etc.) | UIControl mixin with target-action |
| Custom mouse interaction on a view | Override mouseDown:/mouseUp:/mouseDragged: |
| Keyboard input | Override keyDown:/keyUp: + becomeFirstResponder |
| Scroll handling | Override scrollWheel: |
| Event interception/transformation | Override hitSearchSubviews: or eventCallback |
| Tracking areas (hover/enter/exit) | UITrackingArea on the view |

## Phase 2: Design

```bash
mulle-sde api cat MulleUIApplication   # UIEvent, UIResponder, UIControl
mulle-sde api cat MulleUIView          # UIView+UIEvent, hit testing
mulle-sde api cat MulleUIWindow        # UIWindow event routing, first responder
```

Plan:
- What events does the view/control need to handle?
- Does it need first responder status (keyboard focus)?
- Does it need mouse tracking (hover effects)?
- What state changes on events? (highlighted, selected, disabled)
- Does it send target-action?

## Phase 3: Implement

For **UIControl-based widgets** (buttons, switches, sliders):
- Add `UIControlIvars` to the `@interface`
- Add `UIControlProperties` to the `@interface`
- Implement `mouseDown:` / `mouseUp:` with state management
- Call `performClickAndTargetActionCallbacks:` on activation

For **custom event handling views**:
- Override the appropriate event methods (mouseDown:, keyDown:, etc.)
- Return `nil` to consume the event, return the event to pass it up
- Call `[self setNeedsDisplay]` if visual state changed

For **first responder support**:
- Override `canBecomeFirstResponder` to return YES
- Call `[self becomeFirstResponder]` in mouseDown:
- Handle keyDown:/keyUp: for keyboard input

## Phase 4: Verify and Debug

```bash
mulle-sde craft
```

Fix all compiler errors. If tests exist:
```bash
mulle-sde test run test/{relevant}/
```

If a ./demo folder is available, locate or create a demo that can exercise 
your code 

