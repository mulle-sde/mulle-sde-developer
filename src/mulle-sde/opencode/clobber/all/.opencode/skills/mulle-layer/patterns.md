# Layer Patterns

## Minimal layer skeleton

```objc
// MulleFooLayer.h
#import "import.h"

@interface MulleFooLayer : CGGraphicsLayer
{
   CGColor   _fillColor;
   CGFloat   _value;
}

@property( observable, assign) CGColor   fillColor;
@property( observable, assign) CGFloat   value;

@end


// MulleFooLayer.m
#import "import-private.h"

@implementation MulleFooLayer

- (BOOL) drawInContext:(CGContext *) context
{
   CGRect    bounds;

   if( ! [super drawInContext:context])
      return( NO);

   bounds = [self canvas];

   CGContextBeginPath( context);
   CGContextAddRect( context, bounds);
   CGContextFillColor( context, [self fillColor]);
   CGContextFill( context);

   return( YES);
}

@end
```

## Common drawing operations

```objc
// Rectangle
CGContextBeginPath( context);
CGContextAddRect( context, rect);
CGContextFillColor( context, color);
CGContextFill( context);

// Rounded rectangle
CGContextBeginPath( context);
CGContextAddRoundedRect( context, rect, cornerRadius);
CGContextFillColor( context, color);
CGContextFill( context);

// Circle
CGContextBeginPath( context);
CGContextCircle( context, CACircleMake( center, radius));
CGContextFillColor( context, color);
CGContextFill( context);

// Stroke
CGContextBeginPath( context);
CGContextAddRect( context, rect);
CGContextStrokeColor( context, color);
CGContextSetLineWidth( context, 1.0);
CGContextStroke( context);

// Text (via CATextLayer — prefer this over drawing text directly)
```

## Observable properties trigger redraw

Declare visual properties as `observable` so the layer redraws when they change:
```objc
@property( observable, assign) CGColor   fillColor;
@property( observable, assign) CGFloat   value;
```

Non-visual properties (e.g., data that doesn't affect drawing) don't need `observable`.

## Getting canvas bounds

Inside `drawInContext:`, use `[self canvas]` not `[self bounds]`:
```objc
CGRect bounds = [self canvas];
CGPoint center = CGPointMake( bounds.size.width / 2.0, bounds.size.height / 2.0);
CGFloat radius = MIN( bounds.size.width, bounds.size.height) / 2.0 - 2.0;
```

## Disabled state

```objc
if( [self isEnabled])
   CGContextFillColor( context, [self fillColor]);
else
   CGContextFillColor( context, CGColorMakeWithRGBA( 0.5, 0.5, 0.5, 0.5));
```
