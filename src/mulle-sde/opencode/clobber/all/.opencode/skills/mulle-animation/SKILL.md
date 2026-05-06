---
name: mulle-animation
description: Write CAAnimation code — implicit (CATransaction) or explicit (CABasicAnimation, CAPathAnimation).
---

# Animation Executor

Implement MulleCA animations. All sub-files in `.opencode/skills/mulle-animation/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde api apropos "animation"
mulle-sde api apropos "transaction"
mulle-sde code search "CATransaction"
mulle-sde code search "CABasicAnimation"
```

Read `quirks.md` and `patterns.md` now.

Determine which animation approach fits the task:

| Scenario | Approach |
|----------|----------|
| Animate observable properties on a layer/view | CATransaction (implicit) |
| Animate with precise start/end control, no layer | CABasicAnimation (explicit) |
| Animate along a geometric path | CAPathAnimation |
| Multiple animations with shared timing | CATransaction with group |
| Additive/mixable animations | CATransaction with `setAnimationIsAdditive:YES` |

## Phase 2: Design

```bash
mulle-sde api cat MulleCA
```

Plan:
- What properties are being animated? (frame, opacity, color, custom)
- What type are they? (CGRect, CGFloat, CGColor, NSInteger, CGPoint, etc.)
- What timing is needed? (delay, duration, repeat, autoreverses, curve)
- Is the animation additive (mixable with others)?
- Where does the animation live? (window's postLayoutAnimator, custom animator, layer-private)

## Phase 3: Implement

For **implicit animations** (CATransaction):
- Create/get a `CATransaction`
- Call `-begin`
- Configure timing: delay, duration, curve, repeat, autoreverses, additive
- Set the target property to its destination value
- Call `-commit` to get a `CAAnimationGroup`
- Add the group to the appropriate animator

For **explicit animations** (CABasicAnimation):
- Look up the property with `MulleObjCInstanceSearchProperty`
- Create a `CABasicAnimation` with the typed init method
- Set `animationObject`
- Add to an animator or run manually

For **path animations** (CAPathAnimation):
- Create a `CGPath`
- Create a `CAPathAnimation` with property, path, and pathValueType
- Set `animationObject`
- Add to animator

## Phase 4: Verify

```bash
mulle-sde craft
```

Fix all compiler errors. If tests exist:
```bash
mulle-sde test run test/{relevant}/
```
