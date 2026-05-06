# MulleUI Debug Strategies

Diagnostic reference. Read this in Phase 1 before doing anything.

## Always read the howtos first

At the start of every debug session run:

```bash
mulle-sde howto cat debug     # stacktrace workflow, gdb, mulle-sde debug options
mulle-sde howto cat testing   # test file layout, .tmp.* files, vibecoding, retest
mulle-sde debug help          # full list of mulle-sde debug sub-commands
```

These are the authoritative source for how to run and debug tests in this project.
Read them before attempting any manual diagnosis.

## Crash rule: stacktrace FIRST

When a test crashes (non-zero exit, signal, abort), **get the stacktrace before
doing anything else**:

```bash
mulle-sde debug stacktrace [executable] -- [arguments]
```

Or for a test:
```bash
mulle-sde vibecoding on
mulle-sde test run test/{ClassName}/01_failing.m
# executable is left as test/{ClassName}/01_failing.exe
mulle-sde debug stacktrace test/{ClassName}/01_failing.exe
```

Read the stacktrace: frame #0 is the crash site. Fix what it shows — don't guess.

For interactive GDB:
```bash
gdb test/{ClassName}/01_failing.exe
(gdb) run
(gdb) bt
(gdb) frame 2
(gdb) print variable
(gdb) info locals
```

## Vibecoding — enable it

Always enable vibecoding before running tests. It keeps `.tmp.*` files around
for inspection after each test run:

```bash
mulle-sde vibecoding on
```

After a test run, check:
```bash
cat test/{ClassName}/01_failing.tmp.stdout   # actual stdout
cat test/{ClassName}/01_failing.tmp.stderr   # runtime errors / debug output
cat test/{ClassName}/01_failing.tmp.ccerr    # compiler errors/warnings
```

The `.exe` is also kept so you can re-run it with `mulle-sde debug stacktrace`.

## Valgrind — memory errors

```bash
mulle-sde test --valgrind run test/{ClassName}/01_failing.m
```

Use when you suspect invalid memory access, use-after-free, or heap corruption
that doesn't show up as a zombie message.

## Retest — when dependencies changed

If you modified a source file and tests still fail with old behaviour:

```bash
mulle-sde retest
```

This wipes the test kitchen and rebuilds everything from scratch including
dependency updates. Required when working on multiple projects in parallel.


## UIDebuggingFlags — Environment variable system

Every MulleUI class reads its debugging flags at `+initialize` time.
Pass them via `mulle-sde -D` (bare `VAR=VALUE mulle-sde ...` does **not** work):

```bash
mulle-sde -DUIDebuggingFlags=0x3 test run test/{ClassName}/01_failing.m 2>&1 | cat
mulle-sde -DUIWindowDebuggingFlags=0x8 -DCGContextDebuggingFlags=0x8 test run test/{ClassName}/01_failing.m 2>&1 | cat
mulle-sde -DUIDebuggingFlags=0x3 debug demo1 2>&1 | cat
```

**Cascade order** (first match wins):
1. `<ClassName>DebuggingFlags=0xNN`  (class-specific)
2. `UIDebuggingFlags=0xNN`           (global fallback for all classes)

Only set a class-specific var when you need a **different** value for that class than the global.

### Flag reference

**UIView** (`UIViewDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `UIViewDebug` | General UIView lifecycle |
| `0x002` | `UIViewDebugEvent` | Non-motion/non-tracking events |
| `0x004` | `UIViewDebugLayout` | Autoresize / layout passes |
| `0x040` | `UIViewDebugDisplayBits` | Dirty/display bit changes |
| `0x1000` | `UIViewDebugVerbose` | Verbose general |
| `0x2000` | `UIViewDebugEventVerbose` | Verbose events |
| `0x01000000` | `UIViewDebugMouseTrackingEvent` | Tracking events |
| `0x02000000` | `UIViewDebugMouseMotionEvent` | Motion events |

**UIWindow** (`UIWindowDebuggingFlags`) — superset of UIView flags:
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `UIWindowDebug` | General |
| `0x002` | `UIWindowDebugEvent` | Events |
| `0x004` | `UIWindowDebugLayout` | Layout |
| `0x008` | `UIWindowDebugRender` | Render calls |
| `0x010` | `UIWindowDebugThread` | Thread activity |
| `0x020` | `UIWindowDebugWindowEvent` | OS window events |
| `0x040` | `UIWindowDebugDisplayBits` | Display dirty bits |
| `0x080` | `UIWindowDebugRefreshBits` | Refresh bits |
| `0x100` | `UIWindowDebugBackend` | GLFW/SDL backend |
| `0x400` | `UIWindowDebugSwap` | Buffer swap |
| `0x800` | `UIWindowDebugResource` | Resource map |
| `0x1000` | `UIWindowDebugVerbose` | Verbose general |
| `0x2000` | `UIWindowDebugEventVerbose` | Verbose events |
| `0x8000` | `UIWindowDebugRenderVerbose` | Verbose render |
| `0x01000000` | `UIWindowDebugMouseMotionEvent` | Mouse motion |
| `0x02000000` | `UIWindowDebugMouseTrackingEvent` | Mouse tracking |
| `0x08000000` | `UIWindowDebugDumpFrameToFile` | Dump each frame to file |
| `0x40000000` | `UIWindowDebugRenderFrameInfo` | Frame timing info |

**UIApplication** (`UIApplicationDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `UIApplicationDebug` | General app lifecycle |
| `0x002` | `UIApplicationDebugEvent` | Event dispatch |
| `0x1000` | `UIApplicationDebugVerbose` | Verbose general |
| `0x2000` | `UIApplicationDebugEventVerbose` | Verbose event dispatch |
| `0x01000000` | `UIApplicationDebugMouseTrackingEvent` | Tracking events |
| `0x02000000` | `UIApplicationDebugMouseMotionEvent` | Motion events |

**UIControl** (uses `UIViewDebuggingFlags` or `setDebuggingFlags:` on the instance):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `UIControlDebug` | General control |
| `0x002` | `UIControlDebugEvent` | Events |
| `0x004` | `UIControlDebugVerbose` | Verbose |
| `0x2000` | `UIControlDebugEventVerbose` | Verbose events |
| `0x01000000` | `UIControlDebugMouseTrackingEvent` | Tracking |
| `0x02000000` | `UIControlDebugMouseMotionEvent` | Motion |

**CALayer** (`CALayerDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `CALayerDebug` | General layer activity |
| `0x040` | `CALayerDebugDisplayBits` | Display bit changes |
| `0x1000` | `CALayerDebugVerbose` | Verbose |

**CAAnimation** (`CAAnimationDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `CAAnimationDebug` | General animation |
| `0x002` | `CAAnimationDebugInterpolate` | Interpolation steps |
| `0x004` | `CAAnimationDebugState` | State transitions |
| `0x1000` | `CAAnimationDebugVerbose` | Verbose |

**CGContext** (`CGContextDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `CGContextDebug` | General context |
| `0x008` | `CGContextDebugRender` | Render operations |
| `0x1000` | `CGContextDebugVerbose` | Verbose general |
| `0x8000` | `CGContextDebugRenderVerbose` | Verbose render |
| `0x04000000` | `CGContextDebugTraceDrawCalls` | **Enable nanovg draw-call trace to stderr** (see nanovg trace section) |
| `0x08000000` | `CGContextDebugDumpFrameToFile` | Dump each rendered frame to a PNG sequence (`render-layer-NNNNN.png`) |

**CGImage** (`CGImageDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `CGImageDebug` | Image load/create/free |
| `0x1000` | `CGImageDebugVerbose` | Verbose |

**UIOSWindow** (GLFW/SDL backend, `UIOSWindowDebuggingFlags`):
| Value | Constant | What it logs |
|-------|----------|--------------|
| `0x001` | `UIOSWindowDebug` | General OS window |
| `0x002` | `UIOSWindowDebugEvent` | OS-level input events |
| `0x100` | `UIOSWindowDebugBackend` | Backend internals |
| `0x400` | `UIOSWindowDebugSwap` | Buffer swap |
| `0x1000` | `UIOSWindowDebugVerbose` | Verbose |
| `0x2000` | `UIOSWindowDebugEventVerbose` | Verbose events |
| `0x1000000` | `UIOSWindowDebugMouseMotionEvent` | Mouse motion |

### Setting flags in code (instance override)

```objc
[view setDebuggingFlags:UIViewDebugLayout];
[btn setDebuggingFlags:0x7];   // Debug | DebugEvent | DebugVerbose
// propagate window flags to subviews:
[subview setDebuggingFlags:[window debuggingFlags]];
// suppress one flag:
[control setDebuggingFlags:~UIViewDebugMouseTrackingEvent];
```

### Useful combinations

`UIDebuggingFlags` is the global fallback — any class without its own env var uses it.
Only set a class-specific var when you need a **different** value for that class.

| Scenario | Command |
|----------|---------|
| Trace all events end to end | `UIDebuggingFlags=0x3` |
| Debug layout pass | `UIDebuggingFlags=0x4` |
| Debug render pipeline only (UIWindow + CGContext) | `UIWindowDebuggingFlags=0x8 CGContextDebuggingFlags=0x8` |
| Debug image loading only | `CGImageDebuggingFlags=0x1` |
| Debug animation only | `CAAnimationDebuggingFlags=0x7` |
| Everything verbose (noisy!) | `UIDebuggingFlags=0x3007` |
| Render pipeline verbose, events quiet | `UIDebuggingFlags=0x0 UIWindowDebuggingFlags=0x8008 CGContextDebuggingFlags=0x8008` |

## mulle-objc runtime environment variables

These are set as `YES`/`NO` (or `1`/`0`) unless noted otherwise.
All output goes to **stderr**. Always capture with `2>&1 | cat`.

**IMPORTANT:** `mulle-sde` runs in its own managed environment. Prefixing with
`VAR=VALUE mulle-sde ...` does **not** work — the var is stripped. Always use `-D`:

```bash
mulle-sde -DMULLE_OBJC_TRACE_METHOD_CALL=YES test run test/... 2>&1 | cat
```

Multiple vars: chain `-D` flags:
```bash
mulle-sde -DMULLE_OBJC_TRACE_ZOMBIE=YES -DNSZombieEnabled=YES test run test/... 2>&1 | cat
```

### Zombie & leak detection

| Variable | Effect |
|----------|--------|
| `NSZombieEnabled=YES` | Enable zombie objects (Apple-compat alias) |
| `MULLE_OBJC_ZOMBIE_ENABLED=YES` | Enable zombie objects — deallocated objects stay alive as zombies; any message to them prints an error and aborts |
| `MULLE_OBJC_TRACE_ZOMBIE=YES` | Enable zombies **+ full method call trace + instance creation/destruction trace** — use when you need to know what called dealloc |
| `NSDeallocateZombies=YES` | Actually free zombie memory after logging (reduces memory but loses the zombie object) |
| `MULLE_OBJC_DEALLOCATE_ZOMBIE=YES` | Same as above |
| `MULLE_OBJC_PRESERVE_ZOMBIE=YES` | Keep zombie shred protection (default: YES — set NO to shred zombie memory for extra safety) |
| `MULLE_OBJC_TRACE_LEAK=YES` | Enable leak detection: enables full method call trace + instance trace + **pedantic_exit** (runtime checks all objects are released at shutdown, reports leaks) |
| `MULLE_OBJC_PEDANTIC_EXIT=YES` | Force pedantic exit check without full tracing — runtime aborts if any objects remain alive at shutdown |

**`MULLE_OBJC_TRACE_ZOMBIE` and `MULLE_OBJC_TRACE_LEAK` both imply `MULLE_OBJC_PEDANTIC_EXIT`.** The test process exits non-zero if leaks are found.

### Method call tracing

| Variable | Effect | Warning |
|----------|--------|---------|
| `MULLE_OBJC_TRACE_METHOD_CALL=YES` | Trace every single ObjC method call with class, selector, `self` pointer | Extremely noisy |
| `MULLE_OBJC_TRACE_BORING_METHOD_CALL=YES` | Also trace "boring" methods (retain/release/autorelease/dealloc) on top of `TRACE_METHOD_CALL` | Very noisy |
| `MULLE_OBJC_TRACE_METHOD_SEARCH=YES` | Trace every method lookup in the class hierarchy | Fairly excessive |
| `MULLE_OBJC_TRACE_METHOD_ADD=YES` | Trace every method registration at load time |  |
| `MULLE_OBJC_TRACE_METHOD_CACHE=YES` | Trace method cache hits/misses |  |

**Practical tip for "method not being called":** Use `MULLE_OBJC_TRACE_METHOD_CALL=YES` and `grep` for the selector:
```bash
mulle-sde -DMULLE_OBJC_TRACE_METHOD_CALL=YES test run test/Foo/01_test.m 2>&1 | grep "setFillColor"
```

### Instance lifecycle tracing

| Variable | Values | Effect |
|----------|--------|--------|
| `MULLE_OBJC_TRACE_INSTANCE` | `1` or `YES` | Trace alloc/init/dealloc of all objects (shows object pointer, class, retain count) |
| `MULLE_OBJC_TRACE_INSTANCE` | `2` | Same as `1` but skips "boring" system classes — more readable |

Use `MULLE_OBJC_TRACE_INSTANCE=2` first; fall back to `1` if you need to see system allocations.

### Class/method loading traces

| Variable | Effect |
|----------|--------|
| `MULLE_OBJC_TRACE_CLASS_ADD=YES` | Trace each class registration |
| `MULLE_OBJC_TRACE_CLASS_FREE=YES` | Trace class deregistration at shutdown |
| `MULLE_OBJC_TRACE_INITIALIZE=YES` | Trace `+initialize` / `+load` / `+unload` calls |
| `MULLE_OBJC_TRACE_CATEGORY_ADD=YES` | Trace category registration |
| `MULLE_OBJC_TRACE_DEPENDENCY=YES` | Trace class loading dependency resolution |
| `MULLE_OBJC_TRACE_LOADINFO=YES` | Trace full loadinfo (class+category+protocol bundles) |
| `MULLE_OBJC_TRACE_LOAD=YES` | Shorthand: enables `TRACE_LOADINFO` + `TRACE_DEPENDENCY` |

**Useful when a class "doesn't exist":** A crash at `+initialize` time or missing class is often a dependency resolution failure. Use `MULLE_OBJC_TRACE_LOAD=YES` to see the load order.

### Warnings

All warnings require `MULLE_OBJC_WARN_ENABLED=YES` to be active (except `WARN_HANG` and `WARN_CRASH` which are always available).

| Variable | Effect |
|----------|--------|
| `MULLE_OBJC_WARN_ENABLED=YES` | Enable the warning subsystem (enables method_type=NORMAL, stuck_loadable=YES, method_bits=YES by default) |
| `MULLE_OBJC_WARN_METHOD_TYPE=0..3` | `0`=none, `1`=lenient, `2`=normal (default), `3`=strict — warns on method signature mismatches |
| `MULLE_OBJC_WARN_MIXIN=YES` | Warn on mixin usage |
| `MULLE_OBJC_WARN_STUCK_LOADABLE=YES` | Warn on classes that can't finish loading (circular dependency) — **on by default when WARN_ENABLED** |
| `MULLE_OBJC_WARN_METHOD_BITS=YES` | Warn on method flag bit issues — on by default when WARN_ENABLED |
| `MULLE_OBJC_WARN_HANG=YES` | Hang process on any warning (lets debugger attach) |
| `MULLE_OBJC_WARN_CRASH=YES` | Crash (abort) on any warning |

### Convenience bundles

| Variable | Effect |
|----------|--------|
| `MULLE_OBJC_TRACE_ENABLED=YES` | Enable a useful subset: class_add, class_free, fastclass_add, category_add, initialize, protocol_add, state_bit, tagged_pointer |
| `MULLE_OBJC_TRACE_CACHE=YES` | Enable method_cache + class_cache |
| `MULLE_OBJC_TRACE_LOAD=YES` | Enable loadinfo + dependency |

### Thread / TAO / other

| Variable | Effect |
|----------|--------|
| `MULLE_OBJC_TRACE_THREAD=YES` | Trace thread creation/destruction |
| `MULLE_OBJC_TRACE_TAO=YES` | Trace Thread-Affinity-Object checks |
| `MULLE_OBJC_CHECK_TAO=YES` | Enable TAO violation checking on every method call |
| `MULLE_OBJC_TRACE_TIMESTAMP=YES` | Add timestamps to trace output (Linux only) |
| `MULLE_OBJC_TRACE_UNIVERSE=YES` | Trace universe init/retain/release lifecycle |
| `MULLE_OBJC_TRACE_WAITERS_SVG=YES` | Output class-load wait graph as GraphViz SVG |
| `MULLE_OBJC_PRINT_UNIVERSE_CONFIG=YES` | Print universe config at startup |
| `MULLE_OBJC_PRINT_ORIGIN=YES` | Print file:line origin in traces (default: YES) |

### mulle-sde debug command

The preferred way to run tests or demos with env vars — pass `-D` flags to `mulle-sde`:
```bash
mulle-sde -DMULLE_OBJC_TRACE_ZOMBIE=YES -DNSZombieEnabled=YES debug test/Foo/01_test.m
mulle-sde -DMULLE_OBJC_TRACE_METHOD_CALL=YES -DUIDebuggingFlags=0x7 debug demo1
mulle-sde -DMULLE_OBJC_TRACE_ZOMBIE=YES -DNSZombieEnabled=YES test run test/Foo/01_test.m 2>&1 | cat
```

### Diagnostic recipes

**"Method never called" / wrong method dispatched:**
```bash
mulle-sde -DMULLE_OBJC_TRACE_METHOD_CALL=YES test run test/.../01.m 2>&1 | grep -i "methodName"
```

**Crash with no output (likely over-release / use-after-free):**
```bash
mulle-sde -DMULLE_OBJC_TRACE_ZOMBIE=YES -DNSZombieEnabled=YES test run test/.../01.m 2>&1 | cat
```

**Leak — objects not freed at shutdown:**
```bash
mulle-sde -DMULLE_OBJC_TRACE_LEAK=YES test run test/.../01.m 2>&1 | cat
# or for just the exit check without full noise:
mulle-sde -DMULLE_OBJC_PEDANTIC_EXIT=YES test run test/.../01.m 2>&1 | cat
```

**Class not found / +initialize never called:**
```bash
mulle-sde -DMULLE_OBJC_TRACE_LOAD=YES -DMULLE_OBJC_TRACE_INITIALIZE=YES test run test/.../01.m 2>&1 | cat
```

**Crash during startup / class loading:**
```bash
mulle-sde -DMULLE_OBJC_TRACE_ENABLED=YES -DMULLE_OBJC_WARN_ENABLED=YES test run test/.../01.m 2>&1 | cat
```

**Track every alloc/dealloc to find who's leaking:**
```bash
mulle-sde -DMULLE_OBJC_TRACE_INSTANCE=2 test run test/.../01.m 2>&1 | grep "ClassName"
```

## Zombie / memory debugging (MulleUI layer)

```bash
mulle-sde -DNSZombieEnabled=YES test run test/{ClassName}/01_failing.m 2>&1 | cat
```

Zombies fire when a deallocated object receives a message. Output includes the class
name of the zombie and the selector. Look for missing `[super dealloc]`, double-free,
or retained object sent to a released container.

## ⚠️  nanovg trace — most powerful draw-call debugger

`nvgTrace` is the primary tool for understanding **what is being drawn and why**.
It logs every single nanovg API call (BeginPath, Rect, Fill, Stroke, text, etc.) to a FILE.
**Use this whenever drawing output is wrong, empty, or misplaced.**

### Enable via UIDebuggingFlags (no code change required)

```bash
mulle-sde -DUIDebuggingFlags=0x04000000 test run test/{ClassName}/01_failing.m 2>&1 | cat
```

This sets `CGContextDebugTraceDrawCalls` which calls `[context setTraceFile:stderr]` under the hood.
Every nanovg call is printed to stderr with full arguments.

### Enable in code (fine-grained control)

```objc
// In your test or in drawInContext: — redirect trace to stderr or a file
FILE *old = [ctx setTraceFile:stderr];
// ... drawing ...
[ctx setTraceFile:old];   // restore
```

### NVG_NO_DRAWING — headless / no OpenGL context

For tests that don't need actual rendering (just want to verify call sequences):

```c
NVGcontext *vg = nvgCreateGL2(NVG_NO_DRAWING | NVG_ANTIALIAS | NVG_STENCIL_STROKES);
```

`NVG_NO_DRAWING` activates a dummy GL backend — all nanovg calls succeed without
a real OpenGL context. Combine with `nvgTrace` to capture and compare draw call logs
in headless CI environments.

### NANOVG_TRACE compile flag

`nvgTrace` only works if the library was compiled with `-DNANOVG_TRACE`. In MulleCGNanovg
this is controlled by the build. If `setTraceFile:` returns `NULL`, the library was built
without tracing support — check the build flags.

### CGContextDebugDumpFrameToFile — save frames as PNG

```bash
mulle-sde -DCGContextDebuggingFlags=0x08000000 test run test/{ClassName}/01_failing.m
# Produces: render-layer-00000.png, render-layer-00001.png, ...
```

Each completed render frame is written to a PNG file. Use this to inspect what the
framebuffer actually contained at the end of each frame, independent of any screenshot tool.

### Combining trace + frame dump

```bash
mulle-sde -DCGContextDebuggingFlags=0x0C000000 test run test/{ClassName}/01_failing.m 2>&1 | tee trace.log
# 0x0C000000 = TraceDrawCalls | DumpFrameToFile
```

## Demo screenshots — visual regression

### mulle-project-run-demos (X11 only)

```bash
mulle-project-run-demos --screenshot-x11 demo/{DemoName}
```

Takes a screenshot of the running demo window using `scrot` (requires X11 + scrot in PATH).
The demo is launched, a delay is waited, then the window (by class name "Demo") is captured.

```bash
mulle-project-run-demos --gif-x11 demo/{DemoName}     # animated gif from multiple frames
mulle-project-run-demos --video-x11 demo/{DemoName}   # MP4 video (requires ffmpeg)
mulle-project-run-demos --resize-percent 50 ...        # resize output to 50% before saving
```

**Use this to check visual output matches expectations.** Compare the screenshot against
a reference image or visually inspect it to confirm the widget renders correctly.

The screenshots are saved in the current directory (or a tmp dir for gif/video intermediates).
If the demo crashes or exits before the timeout, the script reports failure.

Prerequisites: `scrot` for screenshots, `convert` (ImageMagick) for gif, `ffmpeg` for video.

## Draw call tracing (ObjC layer)

Set on the context directly or via `CGContextDebugTraceDrawCalls` (see nanovg trace section above).

```objc
[ctx setTraceFile:stdout];
[win displayFrameIfNeeded:mulle_absolutetime_now()];
```

Each `CGContext` draw call (`CGContextFill`, `CGContextStroke`, etc.) is logged to the
given FILE with its parameters. Compare against the golden `.stdout` file.

## UIEventPlayer — event injection and replay

`UIEventPlayer` is the primary tool for **simulating user interaction in tests** — clicks,
mouse moves, key presses. It fires real `UIEvent` objects into the application's event loop,
so the full responder chain is exercised exactly as in production.

**Use this when:** a widget behaves incorrectly on click/hover/key input, or you need to
reproduce an interactive bug deterministically in a headless test.

### Script format

Each line: `[N:] <time> <eventType> [parameters]`

- `N:` — optional window index prefix (default: window 0, or `window N` directive)
- `<time>` — seconds since playback started (floating point)
- `<eventType>` — one of: `mouseMove`, `mouseDown`, `mouseUp`, `keyDown`, `keyUp`, `terminate`

```
0.05 mouseDown button=Left x=150 y=80
0.10 mouseUp   button=Left x=150 y=80
0.15 mouseMove x=150 y=110
0.20 keyDown   key=Enter
0.25 keyUp     key=Enter
0.30 terminate
```

Mouse buttons: `Left`, `Right`, `Middle`

Keys: `Space`, `Enter`, `Tab`, `Backspace`, `UIEventKeyEscape`, `Delete`, `Insert`,
`Home`, `End`, `PageUp`, `PageDown`, `Left`, `Right`, `Up`, `Down`, `F1`–`F12`, `A`–`Z`

Modifiers (optional `mods=`): `Shift`, `Control`, `Alt`, `Super`, `CapsLock`, `NumLock`

```
0.20 keyDown key=A mods=Shift
```

### Typical test pattern

```objc
UIEventPlayer *player = [UIEventPlayer instance];
BOOL result = [player loadScriptFromUTF8String:
   "0.05 mouseDown button=Left x=150 y=80\n"
   "0.10 mouseUp   button=Left x=150 y=80\n"
   "0.20 terminate\n"];
assert(result);

[app setEventPlayer:player];
[player startPlayback];

int i = 0;
while (!UIApplicationRequestRunLoopBreak && i < 300)
{
   [app runLoopIteration];
   i++;
}
```

The `terminate` event calls `[app requestTerminate]` to stop the run loop.

### Headless testing with UIWindowStyleNoDrawing

For tests that don't need an actual display (just event handling + nanovg trace):

```objc
win = [UIWindow windowWithFrame:frame
              titleUTF8String:"test"
                    styleMask:UIWindowStyleNoDrawing | UIWindowStyleClearType];
```

`UIWindowStyleNoDrawing` activates the `NVG_NO_DRAWING` dummy GL backend — no OpenGL
context required. Combine with `setTraceFile:stdout` on the context and `UIEventPlayer`
to get a fully deterministic headless test whose output can be golden-file compared.

### Debugging the event player itself

```bash
UIEventPlayerDebuggingFlags=0x1  # General player log (scheduling, timing)
UIEventPlayerDebuggingFlags=0x2  # Per-event dispatch log (skips motion/tracking noise)
UIEventPlayerDebuggingFlags=0x3  # Both
```

### Multi-window scripts

```
window 1
0.05 mouseDown button=Left x=50 y=50
0.10 mouseUp   button=Left x=50 y=50
```

Or inline per-event: `1: 0.05 mouseDown button=Left x=50 y=50`

### When events don't fire as expected

1. Check `UIApplicationDebuggingFlags=0x3` to see event dispatch in the app
2. Check `UIViewDebuggingFlags=0x3` to see which views receive events
3. Add `UIEventPlayerDebuggingFlags=0x3` to trace the player's scheduling
4. Verify window index is correct — wrong index causes player to abort (or skip if `setAbortOnInvalidWindowIndex:NO`)
5. Verify `[app setEventPlayer:player]` is called **before** `[player startPlayback]`

## API existence check

Never assume an API exists. Verify:
```bash
mulle-sde code grep --declarations "{functionOrMethodName}"
mulle-sde api apropos "{keyword}"
```

## Common root causes and fixes

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Crash in `drawInContext:` | Used `[self bounds]` instead of `[self canvas]` | Change to `[self canvas]` |
| Crash sending message to deallocated object | Missing `[super dealloc]` or double-free | Add `[super dealloc]`, check dealloc |
| Draw output empty / no draw calls | Layer not attached to view | Add `+layerClass` override in view |
| State not updated after event | `setNeedsDisplay` not called | Call `[self setNeedsDisplay]` in `didAcceptEvent:` |
| Compile error: unknown type `CGContextRef` | Wrong type used | Use `CGContext *` |
| Compile error: `drawRect:` not found | Apple UIKit method used | Use `drawInContext:(CGContext *) context` on layer |
| Golden file diff: extra/missing newline | `mulle_fprintf` format mismatch | Fix format string |
| Test output has wrong values | Property not forwarded to layer | Add forwarding setter in view |
| Crash with no zombie output | Stack overflow or null deref | Add `mulle_fprintf(stderr,...)` before suspected line |
