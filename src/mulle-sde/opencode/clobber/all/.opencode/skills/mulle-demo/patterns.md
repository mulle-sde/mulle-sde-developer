# Demo Patterns

## Minimal demo

```objc
#import "import.h"

static void setupSceneInView( UIView *contentView)
{
   UIFoo   *widget;
   CGRect  frame;

   frame  = CGRectMake( 20.0, 20.0, 200.0, 50.0);
   widget = [UIFoo viewWithFrame:frame];
   [widget setValue:0.5];
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
                      titleUTF8String:"UIFoo Demo"
                            styleMask:styleMask];
   [window setBackgroundColor:CGColorMakeWhite()];
   setupSceneInView( [window contentView]);
   [app addWindow:window];

   return( [app runApp]);
}
```

## Multiple widgets

```objc
static void setupSceneInView( UIView *contentView)
{
   CGFloat   y = 20.0;

   UIFoo *a = [UIFoo viewWithFrame:CGRectMake( 20, y, 200, 40)];
   [a setTitleUTF8String:"First"];
   [contentView addSubview:a];
   y += 60.0;

   UIFoo *b = [UIFoo viewWithFrame:CGRectMake( 20, y, 200, 40)];
   [b setTitleUTF8String:"Second"];
   [b setEnabled:NO];
   [contentView addSubview:b];
}
```

## Demo file naming

`demo/src/main-{widgetname}.m` — all lowercase, hyphenated.

Examples: `main-uibutton.m`, `main-uislider.m`, `main-mullepopupbutton.m`

## Import

Demos use the project's import header:
```objc
#import "import.h"
```

Not `#import <ProjectName/ProjectName.h>` — that's for external consumers.
