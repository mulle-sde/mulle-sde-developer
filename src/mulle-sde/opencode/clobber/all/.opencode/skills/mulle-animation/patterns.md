# Animation Patterns

## Implicit animation with CATransaction (preferred for layers/views)

Animate observable properties by setting their destination value inside a transaction:

```objc
CATransaction      *ta;
CAAnimationGroup   *group;

ta = [CATransaction instance];
[ta begin];
{
   [ta setAnimationDuration:2.0];
   [ta setAnimationCurve:UIViewAnimationCurveEaseInOut];
   [ta setAnimationAutoreverses:YES];
   [ta setAnimationRepeatCount:INFINITY];

   [layer setFrame:CGRectMake( 600, 100, 100, 100)];
}
group = [ta commit];
[[window postLayoutAnimator] addAnimation:group];
```

## CATransaction timing properties

```objc
[ta setAnimationDelay:1.0];           // seconds before animation starts
[ta setAnimationDuration:2.0];        // seconds for one cycle
[ta setAnimationRepeatCount:3.0];     // number of cycles (INFINITY for forever)
[ta setAnimationAutoreverses:YES];    // ping-pong (requires repeatCount > 1)
[ta setAnimationIsAdditive:YES];      // mix with other animations on same property
[ta setAnimationOffset:0.5];          // start at 50% through the animation
```

## Easing curves

There are two easing mechanisms — see "Tweening system" section below for full details.

Built-in cubic curves (set via `setAnimationCurve:`):
```objc
UIViewAnimationCurveEaseInOut   // default — cubic Bezier
UIViewAnimationCurveEaseIn
UIViewAnimationCurveEaseOut
UIViewAnimationCurveLinear
```

Extended tween curves (Robert Penner style, also set via `setAnimationCurve:`):
```objc
CAAnimationCurveEaseInQuad / EaseOutQuad / EaseInOutQuad
CAAnimationCurveEaseInCubic / EaseOutCubic / EaseInOutCubic
CAAnimationCurveEaseInQuart / EaseOutQuart / EaseInOutQuart
CAAnimationCurveEaseInQuint / EaseOutQuint / EaseInOutQuint
CAAnimationCurveEaseInSine / EaseOutSine / EaseInOutSine
CAAnimationCurveEaseInExpo / EaseOutExpo / EaseInOutExpo
CAAnimationCurveEaseInCirc / EaseOutCirc / EaseInOutCirc
CAAnimationCurveEaseInBack / EaseOutBack / EaseInOutBack
CAAnimationCurveEaseInBounce / EaseOutBounce / EaseInOutBounce
CAAnimationCurveEaseInElastic / EaseOutElastic / EaseInOutElastic
```

## Explicit CABasicAnimation (for non-layer objects or precise control)

```objc
struct _mulle_objc_property      *property;
CABasicAnimation                 *animation;
struct CABasicAnimationOptions   options;

property = MulleObjCInstanceSearchProperty( foo, @selector( x));
options  = CABasicAnimationOptionsMakeCurve( mulle_relativetimerange_make( 0, 2.0),
                                             CAAnimationCurveLinear,
                                             1.0,    // repeatCount
                                             NO);    // autoreverses

animation = [[[CABasicAnimation alloc] initWithProperty:property
                                      startIntegerValue:0
                                        endIntegerValue:1000
                                                options:&options] autorelease];
[animation setAnimationObject:foo];
```

## CABasicAnimation typed init methods

Choose the init matching your property type:

```objc
// NSInteger
initWithProperty:startIntegerValue:endIntegerValue:options:

// CGFloat
initWithProperty:startFloatValue:endFloatValue:options:

// CGPoint / CGSize / CGVector (CGFloat2)
initWithProperty:startPointValue:endPointValue:options:
initWithProperty:startSizeValue:endSizeValue:options:
initWithProperty:startFloat2Value:endFloat2Value:options:

// CGRect (CGFloat4)
initWithProperty:startRectValue:endRectValue:options:

// MulleEdgeInsets
initWithProperty:startEdgeInsetsValue:endEdgeInsetsValue:options:

// NSRange
initWithProperty:startRangeValue:endRangeValue:options:

// BOOL
initWithProperty:startBOOLValue:endBOOLValue:options:

// id <CAInterpolatableValue> (objects like CGColor)
initWithProperty:startObjectValue:endObjectValue:options:

// float array
initWithProperty:startFloatArrayValue:endFloatArrayValue:options:
```

## CABasicAnimationOptions convenience constructors

```objc
// Linear with repeat and reverse
CABasicAnimationOptionsMakeLinear( mulle_relativetimerange_make( delay, duration),
                                   repeatCount, autoreverses)

// EaseInOut with repeat and reverse
CABasicAnimationOptionsMakeEaseInOut( mulle_relativetimerange_make( delay, duration),
                                      repeatCount, autoreverses)

// Any curve
CABasicAnimationOptionsMakeCurve( mulle_relativetimerange_make( delay, duration),
                                   CAAnimationCurveEaseOutBounce,
                                   repeatCount, autoreverses)

// Tween function
CABasicAnimationOptionsMakeTween( mulle_relativetimerange_make( delay, duration),
                                   CATweenEaseOutBounce,
                                   repeatCount, autoreverses)
```

## Running explicit animations with CAAnimator

```objc
CAAnimator   *animator;

animator = [CAAnimator instance];
[animator addAnimation:animation];

// In a render loop:
[animator animateWithAbsoluteTime:now
                    animationRate:1.0 / 60.0];
```

Or use the window's built-in animator:
```objc
[[window postLayoutAnimator] addAnimation:animation];
```

## Additive animations (mixing multiple on same property)

```objc
// First animation
[ta begin];
{
   [ta setAnimationDuration:2.0];
   [ta setAnimationAutoreverses:YES];
   [ta setAnimationRepeatCount:INFINITY];
   [ta setAnimationIsAdditive:YES];
   [layer setFrame:CGRectMake( 600, 100, 100, 100)];
}
group = [ta commit];
[[window postLayoutAnimator] addAnimation:group];

// Second animation — adds to the first, doesn't replace
[ta begin];
{
   [ta setAnimationDelay:0.5];
   [ta setAnimationDuration:2.0];
   [ta setAnimationAutoreverses:YES];
   [ta setAnimationRepeatCount:INFINITY];
   [ta setAnimationIsAdditive:YES];
   [layer setFrame:CGRectMake( 100, 400, 100, 100)];
}
group = [ta commit];
[[window postLayoutAnimator] addAnimation:group];
```

**WARNING:** If `setAnimationIsAdditive:NO` (default), the second animation removes
all previous animations on the same layer's properties.

## CAPathAnimation (animate along a path)

```objc
CGPath   *path;
CGPoint  center = CGPointMake( 400, 300);

path = CGPathCreate( NULL);
CGPathAddArcWithCenter( path, center, 100.0, 0.0, 1.0);

CAPathAnimation *animation;
animation = [CAPathAnimation pathAnimationWithProperty:property
                                                  path:path
                                         pathValueType:CAPathAnimationValuePosition
                                               options:&options];
[animation setAnimationObject:layer];
[[window postLayoutAnimator] addAnimation:animation];
```

Path value types:
```objc
// 1D (CGFloat):
CAPathAnimationValueRotation        // rotation of normal vector
CAPathAnimationValueAngle           // angle of normal vector
CAPathAnimationValueTangentAngle    // angle of tangent
CAPathAnimationValueXPosition       // X coordinate along path
CAPathAnimationValueYPosition       // Y coordinate along path
CAPathAnimationValueDistance        // distance traveled

// 2D (CGPoint/CGSize/CGVector):
CAPathAnimationValuePosition        // point along path
CAPathAnimationValueNormal          // normal vector
CAPathAnimationValueTangent         // tangent vector
CAPathAnimationValuePositionPlusNormal  // point offset by normal

// CGRect:
CAPathAnimationValuePose            // store pose as-is
CAPathAnimationValuePositionAsOrigin // move frame origin along path
CAPathAnimationValuePositionAsSize   // vary frame size along path
```

## Headless animation test pattern

For tests that verify animation values without a window:

```objc
@interface Foo : NSObject
@property( assign) NSInteger   x;
@end

@implementation Foo
- (void) setX:(NSInteger) x
{
   _x = x;
   printf( "%td\n", x);
}
@end

int main( void)
{
   Foo                              *foo;
   CABasicAnimation                 *animation;
   struct CABasicAnimationOptions   options;
   struct _mulle_objc_property      *property;

   foo      = [Foo instance];
   property = MulleObjCInstanceSearchProperty( foo, @selector( x));
   options  = CABasicAnimationOptionsMakeLinear( mulle_relativetimerange_make( 0, 1.0),
                                                 1.0, NO);

   animation = [[[CABasicAnimation alloc] initWithProperty:property
                                         startIntegerValue:0
                                           endIntegerValue:1000
                                                   options:&options] autorelease];
   [animation setAnimationObject:foo];

   CAAnimator *animator = [CAAnimator instance];
   [animator addAnimation:animation];

   double t;
   for( t = 0.0; t <= 1.2; t += 0.2)
      [animator animateWithAbsoluteTime:t
                          animationRate:0.0];
   return( 0);
}
```

## Tweening system — two mechanisms

MulleCA has two independent easing mechanisms. You use one OR the other, not both.

### 1. CACubic (cubic Bezier curves) — 4 presets

A `CACubic` is a 4-control-point cubic Bezier evaluated over t=[0,1].
Used by the first 4 `CAAnimationCurve` values:

```objc
CACubicLinear     // { 0.0, 0.333, 0.666, 1.0 } — constant speed
CACubicEaseIn     // { 0.0, 0.0,   0.1,   1.0 } — slow start, fast end
CACubicEaseOut    // { 0.0, 0.9,   0.9,   1.0 } — fast start, slow end
CACubicEaseInOut  // { 0.0, 0.025, 0.975, 1.0 } — slow start and end
```

Custom cubic: create your own `CACubic` with 4 control values (all 0.0–1.0):
```objc
CACubic custom = CACubicMake( 0.0, 0.4, 0.6, 1.0);
```

Set via `CAAnimationCurve` enum on a transaction or options struct:
```objc
[ta setAnimationCurve:UIViewAnimationCurveEaseInOut];
// or in options:
options = CABasicAnimationOptionsMakeCurve( timeRange, CAAnimationCurveEaseInOut, 1.0, NO);
```

### 2. CATweenFunction (Robert Penner easing) — 30 functions

A `CATweenFunction` is a C function pointer: `CGFloat fn(struct CACubic *q, CGFloat t)`.
The `CACubic *q` parameter is unused by the built-in tweens (pass NULL).

Each family has EaseIn, EaseOut, and EaseInOut variants:

| Family | Behavior | EaseIn formula |
|--------|----------|----------------|
| **Quad** | Quadratic acceleration | t² |
| **Cubic** | Cubic acceleration | t³ |
| **Quart** | Quartic acceleration | t⁴ |
| **Quint** | Quintic acceleration | t⁵ |
| **Sine** | Sinusoidal (gentle) | 1 - cos(t·π/2) |
| **Expo** | Exponential (aggressive) | 2^(10t-10) |
| **Circ** | Circular arc | 1 - √(1-t²) |
| **Back** | Overshoots then settles | c3·t³ - c1·t² (c1=1.70158) |
| **Bounce** | Ball-drop bouncing | piecewise quadratic |
| **Elastic** | Spring oscillation | -2^(10t-10)·sin(...) |

EaseOut/EaseInOut are derived automatically:
- EaseOut(t) = 1 - EaseIn(1-t)
- EaseInOut(t) = EaseIn(2t)/2 for t<0.5, else 1 - EaseIn(2-2t)/2

Available function pointers:
```objc
CATweenEaseInQuad / CATweenEaseOutQuad / CATweenEaseInOutQuad
CATweenEaseInCubic / CATweenEaseOutCubic / CATweenEaseInOutCubic
CATweenEaseInQuart / CATweenEaseOutQuart / CATweenEaseInOutQuart
CATweenEaseInQuint / CATweenEaseOutQuint / CATweenEaseInOutQuint
CATweenEaseInSine / CATweenEaseOutSine / CATweenEaseInOutSine
CATweenEaseInExpo / CATweenEaseOutExpo / CATweenEaseInOutExpo
CATweenEaseInCirc / CATweenEaseOutCirc / CATweenEaseInOutCirc
CATweenEaseInBack / CATweenEaseOutBack / CATweenEaseInOutBack
CATweenEaseInBounce / CATweenEaseOutBounce / CATweenEaseInOutBounce
CATweenEaseInElastic / CATweenEaseOutElastic / CATweenEaseInOutElastic
```

### Using tweens with CATransaction

Set via `CAAnimationCurve` enum (maps to the tween internally):
```objc
[ta setAnimationCurve:CAAnimationCurveEaseOutBounce];
```

Or set the function pointer directly:
```objc
[ta setAnimationTweenFunction:CATweenEaseOutBounce];
```

### Using tweens with CABasicAnimationOptions

```objc
// Via curve enum (auto-selects tween or cubic):
options = CABasicAnimationOptionsMakeCurve( mulle_relativetimerange_make( 0, 2.0),
                                            CAAnimationCurveEaseOutElastic,
                                            1.0, NO);

// Via explicit tween function pointer:
options = CABasicAnimationOptionsMakeTween( mulle_relativetimerange_make( 0, 2.0),
                                            CATweenEaseOutElastic,
                                            1.0, NO);
```

### Choosing the right easing

| Effect desired | Recommended |
|----------------|-------------|
| Smooth generic motion | `EaseInOut` (cubic) |
| UI element appearing | `EaseOut` or `EaseOutCubic` |
| UI element disappearing | `EaseIn` or `EaseInCubic` |
| Playful/bouncy feel | `EaseOutBounce` |
| Springy overshoot | `EaseOutBack` or `EaseOutElastic` |
| Snappy response | `EaseOutExpo` |
| Gentle/organic | `EaseInOutSine` |
| Heavy/dramatic | `EaseInOutQuint` |

## Demo animation pattern (with window)

```objc
static void   setupAnimation( UIWindow *window)
{
   CGGraphicsLayer   *layer;
   CATransaction     *ta;
   CAAnimationGroup  *group;

   layer = [CGGraphicsLayer layerWithFrame:CGRectMake( 100, 100, 50, 50)];
   [layer setBackgroundColor:CGColorMakeWithRGBA( 1.0, 0.0, 0.0, 1.0)];
   [[window contentView] addLayer:layer];

   ta = [CATransaction instance];
   [ta begin];
   {
      [ta setAnimationDuration:2.0];
      [ta setAnimationCurve:CAAnimationCurveEaseOutBounce];
      [ta setAnimationAutoreverses:YES];
      [ta setAnimationRepeatCount:INFINITY];

      [layer setFrame:CGRectMake( 600, 400, 50, 50)];
   }
   group = [ta commit];
   [[window postLayoutAnimator] addAnimation:group];
}
```
