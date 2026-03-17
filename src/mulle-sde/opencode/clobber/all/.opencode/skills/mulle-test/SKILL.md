---
name: mulle-test
description: Write tests for a MulleUI class using trace output and golden files.
---

# Test Executor

Write tests with golden stdout files. All sub-files in `.opencode/skills/mulle-test/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat testing           # MANDATORY — read this first
mulle-sde howto cat styleguide
```

Read `quirks.md` and `patterns.md` now.

Study the class under test:
```bash
mulle-sde code search "{ClassName}"
mulle-sde api apropos "{ClassName}"
```

If the target project has existing tests, read one as a reference:
```bash
ls test/
cat test/{existing}/01_*.m
```

## Phase 2: Design

Plan what to test:
- Initialization (always test this first)
- State transitions (for UIControl subclasses)
- Property get/set round-trips
- Event handling (mouseDown/mouseUp sequences)
- Edge cases (nil inputs, boundary values)

Decide verification method:
- **Simple state tests** — `mulle_fprintf(stdout, ...)` + golden `.stdout` file
- **Draw call verification** — `[view setDrawCallTracer:stdout]` + golden `.stdout`
- **Event replay** — programmatic injection or `UIEventPlayer` script

## Phase 3: Implement

Test files go in `test/{ClassName}/` (create the directory).

Each test is a standalone `.m` file with `main()`:
```objc
#import "import.h"

int main(void)
{
   // setup
   // exercise
   mulle_fprintf( stdout, "PASS: ...\n");
   return( 0);
}
```

For headless rendering tests:
```objc
UIWindow *win = [UIWindow windowWithFrame:CGRectMake(0,0,200,100)
                          titleUTF8String:"test"
                                styleMask:UIWindowStyleNoDrawing|UIWindowStyleClearType];
[win setFrameRate:UIWindowFrameRateAsync];
```

For draw call tracing:
```objc
[view setDrawCallTracer:stdout];
[win displayFrameIfNeeded:mulle_absolutetime_now()];
```

For event injection:
```objc
struct UIInputState input = { 0 };
input.locationInWindow = CGPointMake( 40, 40);
UIMouseButtonEvent *event = [[[UIMouseButtonEvent alloc]
   initWithInputState:&input
               button:UIEventMouseButtonLeft
               action:UIEventButtonActionDown] autorelease];
[view mouseDown:event];
[view didAcceptEvent:event];
```

## Phase 4: Generate golden files and verify

```bash
mulle-sde test run test/{ClassName}/01_init.m
```

On first run with no `.stdout` file, the test will fail but produce `.test.stdout`. Review it:
```bash
cat test/{ClassName}/01_init.test.stdout
```

If the output is correct, promote it to the golden file:
```bash
cp test/{ClassName}/01_init.test.stdout test/{ClassName}/01_init.stdout
```

Run again to confirm pass:
```bash
mulle-sde test run test/{ClassName}/
```

All tests must pass (exit 0) before reporting done.
