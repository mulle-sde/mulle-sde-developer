# MulleCA Animation Quirks

Critical gotchas specific to MulleCA animations. Read this before writing any code.

## MulleCA is NOT Apple CoreAnimation

- Animations operate **directly** on objects (no presentation tree)
- A MulleCA animation **persistently changes** the property value
- There is no `CAKeyFrameAnimation` — use `CAPathAnimation` for path-following
- There is no `CAMediaTiming` protocol
- `autoreverses` only takes effect if `repeatCount > 1`
- A `repeatCount <= 0` is corrected to `1.0`

## CATransaction reuse

A `CATransaction` instance can be reused. After `-commit` returns the group,
you can call `-begin` again for the next animation:

```objc
ta = [CATransaction instance];

[ta begin];
// ... first animation ...
group1 = [ta commit];

[ta begin];
// ... second animation ...
group2 = [ta commit];
```

## Observable properties required for implicit animation

Only properties declared `observable` in the `@interface` will trigger implicit
animation via CATransaction. If a property isn't observable, CATransaction
won't detect the change.

```objc
@property( observable) CGRect   frame;    // YES — animatable
@property( assign) NSInteger    tag;      // NO — not animatable implicitly
```

## Additive vs non-additive is critical

- `setAnimationIsAdditive:NO` (default) — the commit **removes all existing
  animations** on the affected layer's properties before adding the new one.
- `setAnimationIsAdditive:YES` — the new animation is **added on top** of
  existing ones. Values are read-modify-write rather than absolute.

If you want multiple simultaneous animations on the same object, ALL of them
must be additive.

## Duration of 0 produces nil animation

`CABasicAnimation` init returns `nil` if duration is 0. Always provide a
positive duration.

## animationRate parameter

- Pass `1.0 / hz` (e.g., `1.0 / 60.0`) for frame-quantized animation
- Pass `0.0` for continuous (non-quantized) animation — useful for tests
- Quantization ensures the final value is accurately placed

## Where to add animations

| Context | Where to add |
|---------|-------------|
| Layer/view in a window | `[[window postLayoutAnimator] addAnimation:group]` |
| Standalone test | Create `[CAAnimator instance]` and drive manually |
| Layer-private animation | `[layer addAnimation:animation]` (runs during layer's own animate phase) |

## Property lookup

Always use `MulleObjCInstanceSearchProperty` with the getter selector:

```objc
property = MulleObjCInstanceSearchProperty( obj, @selector( frame));
// NOT @selector( setFrame:)
```

## CABasicAnimation options — NULL means defaults

Passing `NULL` for options gives: `delay=0, duration=1, repeatCount=1, linear, no reverse`.
This is convenient for quick one-shot animations.

```objc
animation = [[[CABasicAnimation alloc] initWithProperty:property
                                      startIntegerValue:0
                                        endIntegerValue:100
                                                options:NULL] autorelease];
```

## Factory methods vs alloc/init

Both exist. Factory methods (`+animationWithProperty:...`) autorelease for you.
Init methods require manual `autorelease`:

```objc
// Factory (preferred):
animation = [CABasicAnimation animationWithProperty:property
                                    startFloatValue:0.0
                                      endFloatValue:1.0
                                            options:&options];

// Init:
animation = [[[CABasicAnimation alloc] initWithProperty:property
                                        startFloatValue:0.0
                                          endFloatValue:1.0
                                                options:&options] autorelease];
```

## Color animation

`CGColor` is animated via the object value path since it conforms to
`CAInterpolatableValue`. Use `startObjectValue:endObjectValue:`:

```objc
// Implicit (preferred for layers with observable color properties):
[ta begin];
{
   [ta setAnimationDuration:1.0];
   [layer setBackgroundColor:CGColorMakeWithRGBA( 0.0, 0.0, 1.0, 1.0)];
}
group = [ta commit];
```

## CGPath creation for CAPathAnimation

```objc
CGPath *path = CGPathCreate( NULL);
CGPathAddArcWithCenter( path, center, radius, startAngle, turns);
// turns: 1.0 = full circle, 0.5 = half circle, -1.0 = reverse full circle

CGPathMoveToPoint( path, point);
CGPathAddLineToPoint( path, point);
CGPathAddCurveToPoint( path, cp1, cp2, end);
```

## No dot syntax, no blocks

Same rules as all mulle-objc code:
```objc
[ta setAnimationDuration:2.0];   // NOT ta.animationDuration = 2.0
[layer setFrame:rect];           // NOT layer.frame = rect
```

## NEVER guess API names

Verify functions exist before using them:
```bash
mulle-sde code grep --declarations "CABasicAnimationOptionsMake"
mulle-sde code grep "postLayoutAnimator"
```
