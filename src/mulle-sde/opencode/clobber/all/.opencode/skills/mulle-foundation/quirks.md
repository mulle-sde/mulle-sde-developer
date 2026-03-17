# MulleUI / mulle-objc Quirks

Critical gotchas that differ from standard ObjC/UIKit. Read this before writing any code.

## NEVER Guess API Names

If you're unsure whether a function exists, verify it:
```bash
mulle-sde code grep --declarations "<function name>"   # find the declaration
mulle-sde code grep "<function name>"                   # find real usage examples
```
The compiler will catch typos, but if you're inventing a function name from scratch,
check first.

## Data Types

**Foundation classes are NOT available in headers.**
- Headers (`*.h`) can only `#import "import.h"` — NSString, NSArray, NSDictionary are invisible there
- Use `@class Foo;` forward declarations for ObjC types in headers
- Implementation files (`*.m`) use `#import "import-private.h"` to get Foundation

**Strings are `char *`, not `NSString *`.**
```objc
// Header:
@property( assign) char *titleUTF8String;   // name MUST end in UTF8String

// Setter (.m):
- (void) setTitleUTF8String:(char *) s
{
   MulleObjCObjectSetDuplicatedUTF8String( self, &_titleUTF8String, s);
}

// Dealloc (.m):
- (void) dealloc
{
   MulleObjCInstanceDeallocateMemory( self, _titleUTF8String);
   [super dealloc];
}
```

**Colors are `CGColor`, not `CGPaint *`.**
```objc
@property( observable, assign) CGColor fillColor;
// CGColorMakeWithRGBA( r, g, b, a)  — values 0.0–1.0
// CGColorMakeWhite() / CGColorMakeBlack()
```

**Collections: use `struct mulle_array`, not NSArray.**
```objc
// Header ivar:
struct mulle_array   _values;

// Init:
mulle_array_init( &_values, 0, &_MulleObjCContainerCopyCStringKeyCallback,
                  MulleObjCInstanceGetAllocator( self));
// Use:
mulle_array_add( &_values, "string");
char *s = mulle_array_get( &_values, index);
NSUInteger n = mulle_array_get_count( &_values);
// Dealloc:
mulle_array_done( &_values);   // frees all strings automatically
```

## ObjC Style Rules

**No dot syntax.** Ever.
```objc
[self title]          // not self.title
[self setTitle:t]     // not self.title = t
```

**No blocks** (`^`). No `__bridge`. No `atomic`/`weak`/`strong`. No `@synthesize`. No `@import`.

**Use `BOOL` not `bool`.** Use `YES`/`NO` not `true`/`false`.

**No generics** (`NSArray<NSString *>`). No class extensions (`@implementation Foo ()`).

**Instance variables only in `@interface`**, never in `@implementation`.

**Prefer factory methods over alloc/init.**
```objc
UIButton *btn = [UIButton viewWithFrame:frame];   // not [[UIButton alloc] initWithFrame:frame]
```

**Never call `-release` except in `-dealloc`.** Never call `-alloc/-init` without `-autorelease` except inside `-init` methods.

**Event handler return type:**
```objc
- (UIInputEvent *) mouseDown:(UIMouseButtonEvent *) event   // returns UIInputEvent *, not void
{
   // ...
   return( [super mouseDown:event]);
}
```

## Drawing (CGContext)

**Call `[super drawInContext:context]` not `[super prepareContext:context]`.**

**Use `CGContextFillColor` / `CGContextStrokeColor` for simple colors:**
```objc
CGContextFillColor( context, [self fillColor]);
// NOT CGContextFillPaint() — that's for CGPaint objects
```

**Get drawable bounds from `[self canvas]`**, not `[self bounds]`, inside `drawInContext:`.

**Always begin/end paths:**
```objc
CGContextBeginPath( context);
CGContextAddRect( context, rect);
CGContextFill( context);
```

## Build System

**Never edit `cmake/share/` or `cmake/reflect/`** — managed by mulle-sde, changes lost on upgrade/reflect.

**After adding/removing source files, always run `mulle-sde reflect`.**

**The `test/` directory is an ISOLATED mulle-sde project.** Never run `mulle-sde craft` to build tests — use `mulle-sde test run` only.

**`mulle-sde add src/Foo.m`** creates both `Foo.h` and `Foo.m` with `@interface Foo` boilerplate.

## Layer Architecture

Widgets follow a two-layer pattern:
- **Layer** (`MulleFooLayer : CGGraphicsLayer`) — drawing, visual properties, state
- **View** (`UIFoo : UIControl`) — public API, event handling, forwards properties to layer

Visual properties live in the layer. The view forwards them:
```objc
// In UIFoo.m — forward property to layer:
- (void) setFillColor:(CGColor) color
{
   [[self layer] setFillColor:color];
}
```

## Testing

**Golden file pattern:** test writes to stdout, compare against `.stdout` file.
```objc
mulle_fprintf( stdout, "PASS: value is %s\n", value);
```

**Enable draw call trace on a view:**
```objc
[view setDrawCallTracer:stdout];
```

**Headless window (no display needed):**
```objc
win = [UIWindow windowWithFrame:frame
               titleUTF8String:"test"
                     styleMask:UIWindowStyleNoDrawing|UIWindowStyleClearType];
```

**Programmatic event injection:**
```objc
struct UIInputState   input = { 0 };
input.locationInWindow = CGPointMake( 40, 40);
UIMouseButtonEvent *event = [[[UIMouseButtonEvent alloc]
   initWithInputState:&input
               button:UIEventMouseButtonLeft
               action:UIEventButtonActionDown] autorelease];
[view mouseDown:event];
[view didAcceptEvent:event];
```

**Scripted event replay:**
```objc
UIEventPlayer *player = [UIEventPlayer instance];
[player loadScriptFromUTF8String:
   "window 0\n"
   "0.05 mouseDown button=Left x=60 y=35\n"
   "0.10 mouseUp button=Left x=62 y=33\n"];
[app setEventPlayer:player];
[player startPlayback];
```
