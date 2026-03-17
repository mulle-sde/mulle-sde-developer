# View Patterns

## Minimal display-only view

```objc
// UIFooView.h
#import "import.h"

@interface UIFooView : UIView
@property( assign) CGColor   backgroundColor;
@property( assign) char      *labelUTF8String;
@end


// UIFooView.m
#import "import-private.h"

@implementation UIFooView

- (void) initializeWithFrame:(CGRect) frame
{
   [super initializeWithFrame:frame];
   // set defaults
}

- (void) setLabelUTF8String:(char *) s
{
   MulleObjCObjectSetDuplicatedUTF8String( self, &_labelUTF8String, s);
   [self setNeedsDisplay];
}

- (void) dealloc
{
   MulleObjCInstanceDeallocateMemory( self, _labelUTF8String);
   [super dealloc];
}

@end
```

## View with subviews

```objc
- (void) initializeWithFrame:(CGRect) frame
{
   UILabel   *label;

   [super initializeWithFrame:frame];

   label = [UILabel viewWithFrame:CGRectMake( 0, 0, frame.size.width, frame.size.height)];
   [label setTitleUTF8String:"Hello"];
   [self addSubview:label];
   _label = label;   // weak ref — subview is retained by view hierarchy
}

- (void) layoutSubviews
{
   CGRect   bounds;

   [super layoutSubviews];
   bounds = [self bounds];
   [_label setFrame:bounds];
}
```

## Triggering redraw

Call `[self setNeedsDisplay]` after any property change that affects appearance. The layer will redraw on the next frame.
