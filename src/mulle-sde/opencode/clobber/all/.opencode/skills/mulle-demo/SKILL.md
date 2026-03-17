---
name: mulle-demo
description: Write a demo program for a MulleUI widget or view.
---

# Demo Executor

Write a runnable demo program. All sub-files in `.opencode/skills/mulle-demo/`.

| File | When to read |
|------|-------------|
| `quirks.md` | Phase 1 — before writing any code |
| `patterns.md` | Phase 1 — before writing any code |

## Phase 1: Understand

```bash
mulle-sde vibecoding on
mulle-sde howto cat styleguide
mulle-sde api apropos "{widget name}"
```

Read `quirks.md` and `patterns.md` now.

Study existing demos for the pattern:
```bash
ls demo/src/main-*.m
cat demo/src/main-{similar}.m
```

## Phase 2: Design

A demo program:
- Creates a `UIApplication` + `UIWindow`
- Instantiates the widget with a reasonable frame
- Configures it with representative values
- Adds it to the window's content view
- Calls `[app runApp]`

Optionally: if `argc == 2`, enable trace mode (`UIWindowStyleTraceDrawCalls`).

## Phase 3: Implement

Demo files go in `demo/src/main-{widgetname}.m` (lowercase).

```objc
#import "import.h"

static void setupSceneInView( UIView *contentView)
{
   UI{Name}  *widget;
   CGRect    frame;

   frame  = CGRectMake( 20.0, 20.0, 200.0, 50.0);
   widget = [UI{Name} viewWithFrame:frame];
   // configure widget...
   [contentView addSubview:widget];
}

int main( int argc, char *argv[])
{
   UIApplication   *app;
   UIWindow        *window;
   NSUInteger      styleMask;

   app       = [UIApplication sharedInstance];
   styleMask = UIWindowStyleMaskDefault;
   if( argc == 2)
      styleMask = UIWindowStyleMaskBySetting( styleMask, UIWindowStyleTraceDrawCalls, YES);

   window = [UIWindow windowWithFrame:CGRectMake( 0, 0, 800, 600)
                      titleUTF8String:"{Name} Demo"
                            styleMask:styleMask];
   [window setBackgroundColor:CGColorMakeWhite()];
   setupSceneInView( [window contentView]);
   [app addWindow:window];

   return( [app runApp]);
}
```

## Phase 4: Verify

```bash
mulle-sde craft
```

The demo must compile cleanly. It doesn't need to run headlessly — compile success is sufficient verification for a demo.
