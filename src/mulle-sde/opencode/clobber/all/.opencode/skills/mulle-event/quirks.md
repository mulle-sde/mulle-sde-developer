# MulleUI Event Handling Quirks

Critical gotchas for event handling. Read this before writing any code.

## UIResponder — the event dispatch engine

UIResponder is a **mixin** (not a class) that provides the responder chain
mechanism. UIView adopts it. Understanding its three layers is essential:

### Layer 1: handle methods (chain walkers)

These walk the responder chain (self → nextResponder → nextResponder → ...):

```objc
- (UIEvent *) handleEvent:(UIEvent *) event;
- (UIInputEvent *) handleInputEvent:(UIInputEvent *) event;
- (UIMouseMotionEvent *) handleMouseMotionEvent:(UIMouseMotionEvent *) event;
```

`handleEvent:` iterates responders calling `acceptEventWithCallbacks:` on each.
If a responder returns nil, the event is consumed. If it returns the event
unchanged, the next responder is tried.

**UIView overrides `handleInputEvent:`** to do hit testing before dispatching.
The base UIResponder `handleInputEvent:` just returns nil (defers to handleEvent:).

### Layer 2: accept methods (per-responder dispatch)

These classify and route the event to the appropriate handler method:

```objc
- (UIEvent *) acceptEventWithCallbacks:(UIEvent *) event;  // master dispatcher
- (UIInputEvent *) acceptInputEvent:(UIInputEvent *) event;  // routes by eventType
- (UIInputEvent *) acceptMouseButtonEvent:(UIMouseButtonEvent *) event;
- (UIMouseMotionEvent *) acceptMouseMotionEvent:(UIMouseMotionEvent *) event;
- (UIInputEvent *) acceptMouseScrollEvent:(UIMouseScrollEvent *) event;
- (UIInputEvent *) acceptKeyboardEvent:(UIKeyboardEvent *) event;
- (UIInputEvent *) acceptUnicodeEvent:(UIUnicodeEvent *) event;
- (UIInputEvent *) acceptActionEvent:(UIActionEvent *) event;
```

`acceptInputEvent:` switches on `[event eventType]` and calls the typed accept method.
Each typed accept method resolves the final selector (mouseDown:, keyUp:, etc.)
and calls it via `respondsToSelector:` + `performSelector:`.

### Layer 3: handler methods (what you implement)

These are the methods you actually override in your view/control:

```objc
- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event;
- (UIInputEvent *) mouseUp:(UIMouseButtonEvent *) event;
- (UIInputEvent *) rightMouseDown:(UIMouseButtonEvent *) event;
- (UIInputEvent *) rightMouseUp:(UIMouseButtonEvent *) event;
- (UIInputEvent *) otherMouseDown:(UIMouseButtonEvent *) event;
- (UIInputEvent *) otherMouseUp:(UIMouseButtonEvent *) event;
- (UIMouseMotionEvent *) mouseDragged:(UIMouseMotionEvent *) event;
- (UIMouseMotionEvent *) rightMouseDragged:(UIMouseMotionEvent *) event;
- (UIMouseMotionEvent *) otherMouseDragged:(UIMouseMotionEvent *) event;
- (UIInputEvent *) keyDown:(UIKeyboardEvent *) event;
- (UIInputEvent *) keyUp:(UIKeyboardEvent *) event;
- (UIInputEvent *) scrollWheel:(UIMouseScrollEvent *) event;
```

### Callbacks around acceptance

```objc
- (BOOL) willAcceptEvent:(UIEvent *) event;   // return NO to skip this responder
- (void) didAcceptEvent:(UIEvent *) event;    // called after event was transformed
```

## Decision guide: what to override

| You want to... | Override this |
|----------------|-------------|
| Handle left mouse click | `mouseDown:` and/or `mouseUp:` |
| Handle right click | `rightMouseDown:` / `rightMouseUp:` |
| Handle dragging | `mouseDragged:` (also need mouseDown: to start) |
| Handle keyboard | `keyDown:` / `keyUp:` (need firstResponder) |
| Handle scroll wheel | `scrollWheel:` |
| Handle unicode text input | `unicodeCharacterEvent:` |
| Intercept events for children | `hitSearchSubviews:withInputEventPointer:` |
| Transform events before dispatch | `acceptInputEvent:` (call super after) |
| Filter all events for a responder | `willAcceptEvent:` (return NO to skip) |
| React after event consumed | `didAcceptEvent:` |
| Change hit area shape | `pointInside:withEvent:` |
| Redirect events to different view | `handleInputEvent:` on a container view |
| Block event propagation entirely | Return `nil` from any handler |
| Pass event to next responder | Return the event from your handler |

## When NOT to override accept methods

**Don't override `acceptMouseButtonEvent:`** unless you need to change how
button+action maps to selectors. The default correctly maps:
- Left+Down → `mouseDown:`
- Left+Up → `mouseUp:`
- Right+Down → `rightMouseDown:`
- Right+Up → `rightMouseUp:`
- Middle+Down → `otherMouseDown:`
- Middle+Up → `otherMouseUp:`

**Don't override `handleEvent:`** on leaf views. It walks the responder chain.
Override it only if you need to change chain-walking behavior.

**Don't override `handleInputEvent:`** on leaf views. UIView's implementation
does hit testing. Override only on containers that need to intercept/redirect.

## Event methods return UIInputEvent *, not void

All event handler methods return the event (to pass it up) or nil (to consume it):

```objc
- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   // handle...
   return( nil);  // consumed — stops propagation
   // OR
   return( (UIInputEvent *) event);  // pass to next responder
}
```

**NEVER** declare event handlers as returning `void`.

## Mouse motion requires explicit opt-in

Mouse motion events (mouseDragged:) are only delivered if:
1. The view implements `mouseDragged:` (checked via `isMouseMotionEnabled`)
2. Mouse motion events are not discarded by the window (`discardEventsMask`)

`isMouseMotionEnabled` returns YES if the responder implements any of:
`mouseDragged:`, `otherMouseDragged:`, `rightMouseDragged:`.

## Click vs drag differentiation

There's a built-in suppression delay (`_mouseMotionSuppressionDelay = 0.1s`).
After mouseDown, motion events are suppressed briefly to distinguish clicks
from drags. The responder can change this delay.

## locationInView: vs _locationForView:

- `[event locationInView:self]` — always correct, recalculates from window coords
- `[event _locationForView:self]` — cached value from hit testing, only valid if
  the view was the hit test target

**Always use `locationInView:` unless you're certain the view was hit-tested.**

## UIControl is a mixin (@mixin), not a class

You don't subclass UIControl. You adopt it as a protocol/mixin:

```objc
@interface MyWidget : UIView < UIControl>
{
   UIControlIvars;
}
UIControlProperties;
@end
```

And call `UIControlInit( self)` in your init method.

## setNeedsDisplay after state changes

UIView does NOT automatically redraw when state changes. You must call
`[self setNeedsDisplay]` after any visual state change in event handlers.

UIControl's `reflectState` method helps detect if state actually changed.

## Events are on the window thread (if retained mode)

In `UIWindowBackingStoreRetained` mode (the default), events are processed
on the **window thread**, not the main thread. The main thread only queues
events. This means:
- Don't call main-thread-only APIs from event handlers
- View hierarchy modifications during events are fine (same thread as rendering)

## firstResponder and keyboard events

Keyboard events (`keyDown:`, `keyUp:`, `unicodeEvent:`) go to the
**firstResponder** first, not through hit testing. If no firstResponder
is set, keyboard events go to the window's `_responder` (root view).

The default `isFirstResponderEvent:` behavior:
- Returns YES for all input events EXCEPT mouseDown (UIEventButtonActionDown)
- On mouseDown, it **resigns** first responder and returns NO
- This means: clicking anywhere resigns the current firstResponder

To receive keyboard events:
1. Override `canBecomeFirstResponder` → return YES
2. Call `[self becomeFirstResponder]` (usually in mouseDown:)
3. Implement `keyDown:` / `keyUp:`

## Event type hierarchy

```
UIEvent (base — has timestamp)
├── UIInputEvent (has locationInWindow, keyModifiers, buttonStates)
│   ├── UIMouseButtonEvent (button, action: down/up/repeat)
│   ├── UIMouseMotionEvent (just position change)
│   ├── UIMouseScrollEvent (scrollOffset)
│   ├── UIKeyboardEvent (key, scanCode, action, isARepeat)
│   ├── UIUnicodeEvent (character — interpreted keyboard)
│   └── UIActionEvent (action selector, sender)
├── UIWindowEvent
│   ├── UIWindowCloseEvent
│   ├── UIWindowRefreshEvent
│   ├── UIWindowResizeEvent
│   ├── UIWindowMoveEvent
│   └── UIWindowFramebufferResizeEvent
├── UIScreenEvent (connected/disconnected)
├── UIGamepadEvent (connected/disconnected)
└── UIUserEvent (custom eventIdentifier)
```

Only `UIInputEvent` subclasses are delivered to views via hit testing.

## The full dispatch sequence for a mouseDown

```
1. UIPureWindow receiveEvent:
   → eventType == UIEventTypeTouches
   → saves inputState
   → sets suppression timestamp

2. firstResponder isFirstResponderEvent:
   → sees mouseDown → resigns → returns NO
   → event NOT sent to firstResponder

3. _responder (root UIView) handleInputEvent:
   → translates location to content coords
   → directHitTest: on self (checks userInteraction, pointInside:)
   → hitSearchSubviews: finds deepest hit subview

4. Deepest hit UIView handleEvent:
   → calls eventCallback (if set)
   → calls [super handleEvent:] → UIResponder chain

5. UIResponder handleEvent: walks chain:
   → acceptEventWithCallbacks: on each responder
     → willAcceptEvent: (can skip)
     → acceptInputEvent:
       → acceptMouseButtonEvent:
         → resolves Left+Down → @selector(mouseDown:)
         → respondsToSelector: check
         → [self mouseDown:event]
     → didAcceptEvent: (if event changed)
   → if nil returned: consumed, stop
   → if event returned: try nextResponder (superview)
```

## UIControlEvents mask

UIControl only responds to events matching its `eventMask`. Default is
`UIControlEventLeftMouseDown`. Set the mask to receive other events:

```objc
[control setEventMask:UIControlEventLeftMouseDown | UIControlEventLeftMouseUp];
```

## No blocks, no dot syntax

Same rules as all mulle-objc code:
```objc
[event locationInView:self]    // NOT event.locationInView
[self setHighlighted:YES]      // NOT self.highlighted = YES
```

## NEVER guess API names

```bash
mulle-sde code grep --declarations "mouseDown"
mulle-sde code grep "acceptInputEvent"
mulle-sde code grep "UIControlSelectionBehaviour"
```
