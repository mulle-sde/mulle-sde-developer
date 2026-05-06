# Event Handling Patterns

## Event flow overview

```
OS (GLFW) callbacks
    │
    ▼
UIOSWindow  (_mouseButtonCallback:, _keyCallback:, _mouseMotionCallback:)
    │  creates UIEvent objects
    ▼
UIPureWindow  receiveRetainedEvent:  (main thread)
    │  queues event into _eventQueue
    ▼
UIPureWindow  executeEventQueue  (window thread)
    │  dequeues and calls receiveEvent:
    ▼
UIPureWindow  receiveEvent:
    │  classifies by eventType
    │  window events → handleWindowEvent: (handled here)
    │  firstResponder events → firstResponder handleInputEvent:
    │  input events → _responder handleInputEvent: (the root UIView)
    ▼
UIView  handleInputEvent:
    │  translates location to content coordinates
    │  calls directHitTest: on self
    │  calls hitSearchSubviews: to find deepest hit view
    ▼
Target UIView  handleEvent:
    │  calls eventCallback (C function pointer)
    │  calls [super handleEvent:] → UIResponder chain
    ▼
UIResponder  acceptInputEvent: / acceptMouseButtonEvent: / etc.
    │  dispatches to mouseDown: / mouseUp: / keyDown: etc.
    ▼
UIControl (if applicable)
    │  manages state (highlighted, selected)
    │  calls performClickAndTargetActionCallbacks:
    ▼
Target-Action delivery
```

## Handling mouse clicks (simplest case)

```objc
@interface MyView : UIView
@end

@implementation MyView

- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   CGPoint   point;

   point = [event locationInView:self];
   // do something with the click location...
   [self setNeedsDisplay];
   return( nil);  // consumed
}

@end
```

## UIControl-based widget (target-action)

```objc
// MyButton.h
#import "import.h"

@interface MyButton : UIView < UIControl>
{
   UIControlIvars;
}

UIControlProperties;

@end


// MyButton.m
#import "import-private.h"

@implementation MyButton

- (instancetype) initWithLayer:(id <UILayer>) layer
                         frame:(CGRect) frame
{
   self = [super initWithLayer:layer frame:frame];
   UIControlInit( self);
   return( self);
}

- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   [self setHighlighted:YES];
   [self setNeedsDisplay];
   return( nil);
}

- (UIInputEvent *) mouseUp:(UIMouseButtonEvent *) event
{
   [self setHighlighted:NO];
   [self setNeedsDisplay];
   return( [self performClickAndTargetActionCallbacks:event]);
}

@end
```

Usage:
```objc
MyButton *btn = [MyButton viewWithFrame:frame];
[btn setTarget:self];
[btn setAction:@selector( buttonClicked:)];
```

## Mouse dragging

```objc
- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   _dragStart = [event locationInView:self];
   return( nil);
}

- (UIMouseMotionEvent *) mouseDragged:(UIMouseMotionEvent *) event
{
   CGPoint   current;
   CGFloat   dx, dy;

   current = [event locationInView:self];
   dx = current.x - _dragStart.x;
   dy = current.y - _dragStart.y;
   // apply delta...
   [self setNeedsDisplay];
   return( nil);
}

- (UIInputEvent *) mouseUp:(UIMouseButtonEvent *) event
{
   // finalize drag
   return( nil);
}
```

## Keyboard events (first responder)

```objc
- (BOOL) canBecomeFirstResponder
{
   return( YES);
}

- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   [self becomeFirstResponder];
   return( nil);
}

- (UIInputEvent *) keyDown:(UIKeyboardEvent *) event
{
   NSUInteger   key;

   key = [event key];
   switch( key)
   {
   case UIEventKeyEnter :
      // handle enter...
      return( nil);

   case UIEventKeyEscape :
      [self resignFirstResponder];
      return( nil);
   }
   return( (UIInputEvent *) event);  // pass to next responder
}
```

## Scroll wheel

```objc
- (UIInputEvent *) scrollWheel:(UIMouseScrollEvent *) event
{
   CGPoint   offset;

   offset = [event scrollOffsetWithAcceleration:YES
                                   useModifiers:YES];
   // offset.x = horizontal scroll
   // offset.y = vertical scroll
   // apply scroll...
   [self setNeedsDisplay];
   return( nil);
}
```

## Event callback (C function pointer)

For controllers or external event interception without subclassing:

```objc
static UIEvent   *myEventCallback( UIView *view, UIEvent *event)
{
   // return nil to consume, return event to pass through
   if( [event eventType] == UIEventTypeTouches)
   {
      // handle...
      return( nil);
   }
   return( event);
}

// setup:
[view setEventCallback:myEventCallback];
```

## Mouse motion callback

```objc
static UIMouseMotionEvent   *myMotionCallback( UIView *view, UIMouseMotionEvent *event)
{
   // handle hover/motion...
   return( event);  // or nil to consume
}

[view setMouseMotionEventCallback:myMotionCallback];
```

## Hit testing customization

Override to change which subview receives events:

```objc
- (UIView *) hitSearchSubviews:(CGPoint) contentLocation
         withInputEventPointer:(UIInputEvent **) event_p
{
   // transform event, redirect to different subview, or block
   *event_p = nil;  // block event propagation
   return( nil);
}
```

## Responder chain

```
Target UIView
    → superview (nextResponder)
        → superview's superview
            → ... up to root view
                → window (_responder)
                    → nil (event unhandled)
```

Each responder can:
- Return `nil` → event consumed, chain stops
- Return the event → passes to `nextResponder`

## UIControlState management

```objc
// States are bitmask:
UIControlStateNormal        // 0x0
UIControlStateHighlighted   // 0x1 — mouse is pressing
UIControlStateDisabled      // 0x2 — control is disabled
UIControlStateSelected      // 0x4 — toggle is on
UIControlStateFirstResponder // 0x10 — has keyboard focus

// Selection behaviours:
UIControlSelectionBehaviourPush          // select on down, deselect on up (momentary)
UIControlSelectionBehaviourRelease       // select on up (click)
UIControlSelectionBehaviourPushSwitch    // toggle on down
UIControlSelectionBehaviourReleaseSwitch // toggle on up
```

## Scripted event playback (for testing)

```objc
UIEventPlayer *player = [UIEventPlayer instance];
[player loadScriptFromUTF8String:
   "window 0\n"
   "0.05 mouseDown button=Left x=60 y=35\n"
   "0.10 mouseUp button=Left x=62 y=33\n"
   "0.20 keyDown key=A\n"
   "0.25 keyUp key=A\n"];
[app setEventPlayer:player];
[player startPlayback];
```

## Programmatic event injection (for tests)

```objc
struct UIInputState   input = { 0 };
input.locationInWindow = CGPointMake( 40, 40);

UIMouseButtonEvent *event;
event = [[[UIMouseButtonEvent alloc] initWithInputState:&input
                                                button:UIEventMouseButtonLeft
                                                action:UIEventButtonActionDown] autorelease];
[view mouseDown:event];
```

## Window event receiver (intercept all events)

```objc
@interface MyReceiver : NSObject <UIEventReceiver>
@property( retain) UIWindow *window;
@end

@implementation MyReceiver

- (void) receiveRetainedEvent:(UIEvent *) event
{
   // log, filter, transform...
   [_window receiveRetainedEvent:event];
}

- (UIWindowEvent *) handleWindowEvent:(UIWindowEvent *) event
{
   return( [_window handleWindowEvent:event]);
}

@end

// install:
id <UIOSWindow> osWindow = [window OSWindow];
[osWindow setEventsReceiver:myReceiver];
[osWindow setWindowEventsReceiver:myReceiver];
```
