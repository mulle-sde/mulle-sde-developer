# Widget Patterns

## Minimal widget skeleton

```objc
// UIFoo.h
#import "import.h"

@interface UIFoo : UIControl
@property( assign) CGColor   fillColor;
@property( assign) CGFloat   value;
@end


// UIFoo.m
#import "import-private.h"
#import "MulleFooLayer.h"

@implementation UIFoo

+ (Class) layerClass
{
   return( [MulleFooLayer class]);
}

- (void) initializeWithFrame:(CGRect) frame
{
   [super initializeWithFrame:frame];
   [[self layer] setFillColor:CGColorMakeWithRGBA( 0.2, 0.5, 0.9, 1.0)];
}

// Forward visual properties to layer
- (CGColor) fillColor          { return( [[self layer] fillColor]); }
- (void) setFillColor:(CGColor) c { [[self layer] setFillColor:c]; }
- (CGFloat) value              { return( [[self layer] value]); }
- (void) setValue:(CGFloat) v  { [[self layer] setValue:v]; }

// Event handling
- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event
{
   [self setHighlighted:YES];
   return( [super mouseDown:event]);
}

- (UIInputEvent *) mouseUp:(UIMouseButtonEvent *) event
{
   [self setHighlighted:NO];
   return( [super mouseUp:event]);
}

- (void) didAcceptEvent:(UIInputEvent *) event
{
   [self setNeedsDisplay];
   [super didAcceptEvent:event];
}

@end
```

## State-based drawing in the layer

```objc
- (BOOL) drawInContext:(CGContext *) context
{
   CGColor   color;

   if( ! [super drawInContext:context])
      return( NO);

   if( [self isHighlighted])
      color = CGColorMakeWithRGBA( 0.1, 0.3, 0.7, 1.0);
   else if( ! [self isEnabled])
      color = CGColorMakeWithRGBA( 0.5, 0.5, 0.5, 0.5);
   else
      color = [self fillColor];

   // draw with color...
   return( YES);
}
```

## Target-action (notify observers)

```objc
// In mouseUp or value-change handler:
[self sendActionsForControlEvents:UIControlEventValueChanged];
// or:
[self sendActionsForControlEvents:UIControlEventTouchUpInside];
```

## Autoresizing

Set in `initializeWithFrame:` if the widget should resize with its parent:
```objc
[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
```

## sizeThatFits:

Implement if the widget has a natural size:
```objc
- (CGSize) sizeThatFits:(CGSize) size
{
   return( CGSizeMake( MAX( size.width, 100.0), 32.0));
}
```
