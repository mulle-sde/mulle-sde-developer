# Test Patterns

## Minimal test skeleton

```objc
#import "import.h"

int main(void)
{
   UIFoo   *widget;
   CGRect  frame;

   frame  = CGRectMake( 0, 0, 200, 50);
   widget = [UIFoo viewWithFrame:frame];

   mulle_fprintf( stdout, "PASS: created\n");
   mulle_fprintf( stdout, "value: %g\n", [widget value]);

   return( 0);
}
```

## Headless rendering + trace

```objc
#import "import.h"

int main(void)
{
   UIFoo    *widget;
   UIWindow *win;

   win = [UIWindow windowWithFrame:CGRectMake( 0, 0, 300, 100)
                   titleUTF8String:"test"
                         styleMask:UIWindowStyleNoDrawing|UIWindowStyleClearType];
   [win setFrameRate:UIWindowFrameRateAsync];

   widget = [UIFoo viewWithFrame:CGRectMake( 10, 10, 200, 50)];
   [widget setDrawCallTracer:stdout];
   [win setContentView:widget];

   mulle_fprintf( stdout, "--- frame 0 ---\n");
   [win displayFrameIfNeeded:mulle_absolutetime_now()];

   return( 0);
}
```

## Event injection

```objc
struct UIInputState   input;
UIMouseButtonEvent    *event;

input                  = (struct UIInputState){ 0 };
input.locationInWindow = CGPointMake( 40, 25);

event = [[[UIMouseButtonEvent alloc]
   initWithInputState:&input
               button:UIEventMouseButtonLeft
               action:UIEventButtonActionDown] autorelease];
[widget mouseDown:event];
[widget didAcceptEvent:event];

mulle_fprintf( stdout, "state after mouseDown: %s\n",
   UIControlStateUTF8String( [widget state]));

[win displayFrameIfNeeded:mulle_absolutetime_now()];
```

## Golden file workflow

1. Write test, run: `mulle-sde test run test/UIFoo/01_init.m`
2. First run fails (no `.stdout`), produces `.tmp.stdout`
3. Review: `cat test/UIFoo/01_init.tmp.stdout`
4. If correct: `cp test/UIFoo/01_init.tmp.stdout test/UIFoo/01_init.stdout`
5. Run again to confirm: `mulle-sde test run test/UIFoo/`

## Test naming convention

```
test/{ClassName}/01_initialization.m    # always first
test/{ClassName}/02_state_transitions.m
test/{ClassName}/03_event_handling.m
test/{ClassName}/04_edge_cases.m
```

## Checking compiler errors

```bash
cat test/{ClassName}/01_init.tmp.ccerr
```
