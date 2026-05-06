---
name: mulle-debug
description: Debug test failures and runtime crashes in a MulleUI mulle-sde project.
---

# Debug Executor

Diagnose and fix test failures and runtime crashes. Read `strategies.md` in Phase 1.

| File | When to read |
|------|-------------|
| `strategies.md` | Phase 1 — before doing anything else |

## Phase 1: Understand the failure

Read `strategies.md` now.

Read the howtos — they are mandatory:
```bash
mulle-sde vibecoding on
mulle-sde howto cat debug
mulle-sde howto cat testing
mulle-sde debug help
```

Re-run the failing test to get fresh `.tmp.*` files:
```bash
mulle-sde test run test/{ClassName}/01_failing.m
```

Inspect all output files:
```bash
cat test/{ClassName}/01_failing.tmp.stdout   # actual stdout
cat test/{ClassName}/01_failing.tmp.stderr   # runtime errors
cat test/{ClassName}/01_failing.tmp.ccerr    # compiler errors/warnings
```

Determine failure type from the output:
- **Golden file mismatch** — stdout differs from `.stdout` file
- **Crash / signal** — non-zero exit, abort, or signal in stderr
- **Compile error** — content in `.tmp.ccerr`
- **Hang** — test times out

## Phase 2: Diagnose

Choose your primary diagnostic tool based on failure type — see `strategies.md`.

**Golden file mismatch** — output differs from expected:
- Diff actual vs expected to understand what changed:
```bash
diff test/{ClassName}/01_failing.stdout test/{ClassName}/01_failing.tmp.stdout
```
- Read the diff carefully: what is extra, missing, or wrong?
- Enable draw call tracing or state logging on the object under test.
- Re-run with debugging flags to get more trace output:
```bash
UIDebuggingFlags=0x7 mulle-sde test run test/{ClassName}/01_failing.m
```
- If the golden file itself is wrong (test logic changed intentionally), update it — do NOT blindly promote bad output.

**Crash / signal** — test exits non-zero with no output or a signal:
- **Get a stacktrace first** — see `strategies.md` for the full workflow:
```bash
mulle-sde debug stacktrace test/{ClassName}/01_failing.exe
```
- Read frame #0 — that is the crash site. Fix what it shows before trying env vars.
- Enable zombie detection to catch over-releases:
```bash
MULLE_OBJC_TRACE_ZOMBIE=YES NSZombieEnabled=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```
- Use `MULLE_OBJC_TRACE_INSTANCE=2` to watch object lifecycle and spot the bad dealloc:
```bash
MULLE_OBJC_TRACE_INSTANCE=2 mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | grep "{ClassName}"
```
- Enable UIApplication and UIView debugging to trace where it dies:
```bash
UIDebuggingFlags=0x3 mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```
- Check if any API called in the test actually exists:
```bash
mulle-sde code grep --declarations "{suspectedFunctionName}"
```
- If crashing during startup (class not found, +initialize crash):
```bash
MULLE_OBJC_TRACE_LOAD=YES MULLE_OBJC_TRACE_INITIALIZE=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```

**Method never called / wrong dispatch** — expected method not reached:
```bash
MULLE_OBJC_TRACE_METHOD_CALL=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | grep "{methodName}"
```
If that's too noisy, also check the method is actually registered:
```bash
MULLE_OBJC_TRACE_METHOD_ADD=YES MULLE_OBJC_TRACE_INITIALIZE=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | grep "{ClassName}"
```

**Objects leaking / pedantic exit failure:**
```bash
MULLE_OBJC_TRACE_LEAK=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
# quieter — just checks at exit, no full call trace:
MULLE_OBJC_PEDANTIC_EXIT=YES mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```


- Set draw call tracer on the view:
```objc
[view setDrawCallTracer:stdout];
[win displayFrameIfNeeded:mulle_absolutetime_now()];
```
- Enable CGContext render logging:
```bash
CGContextDebuggingFlags=0x8 mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```

**Event handling wrong** — state after event injection is incorrect:
- Enable UIView event + UIControl event logging:
```bash
UIViewDebuggingFlags=0x6 mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```
- Trace the event sequence: add `mulle_fprintf(stderr, ...)` in the handler to print state.

**Layout wrong** — subview frames or autoresize incorrect:
```bash
UIViewDebuggingFlags=0x4 mulle-sde test run test/{ClassName}/01_failing.m 2>&1 | cat
```

## Phase 3: Fix

Fix the **root cause** — not just the symptom. Common causes:

- Forgot `[super drawInContext:context]` call
- Used `[self bounds]` instead of `[self canvas]` inside `drawInContext:`
- Used `CGContextRef` instead of `CGContext *`
- Used `void` return on an event handler instead of `UIInputEvent *`
- Forgot `mulle-sde reflect` after adding/removing files
- String property not using `MulleObjCObjectSetDuplicatedUTF8String` in setter
- Missing `mulle_array_done` or `MulleObjCInstanceDeallocateMemory` in `dealloc`
- Wrong event type check (motion/tracking events filtered out unexpectedly)
- Layer not attached: missing `+layerClass` override in the view
- `setNeedsDisplay` not called after state change in `didAcceptEvent:`

After fixing:
```bash
mulle-sde craft
```

Fix all compile errors before proceeding.

## Phase 4: Verify

Re-run the failing test:
```bash
mulle-sde test run test/{ClassName}/01_failing.m
```

If golden file needs updating (output is now correct but different from old golden):
```bash
cp test/{ClassName}/01_failing.tmp.stdout test/{ClassName}/01_failing.stdout
mulle-sde test run test/{ClassName}/01_failing.m
```

Run the full test suite for the class to ensure no regressions:
```bash
mulle-sde test run test/{ClassName}/
```

All tests must pass (exit 0) before reporting done. Report:
- Root cause found
- Fix applied
- All tests passing
