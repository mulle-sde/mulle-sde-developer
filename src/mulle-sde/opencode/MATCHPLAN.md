# MulleUI-gen: Porting Godogen's Pipeline to MulleUI Development

## Concept

Reuse Godogen's orchestrator/executor architecture to generate mulle-objc code — widgets, views, layers, apps — in any mulle-sde project that depends on MulleUI. The user describes what they want, the pipeline decomposes it into tasks, generates code, compiles, tests, and iterates.

The generator operates in the user's **target project** — a mulle-sde project that depends on MulleUI. MulleUI source is available in the mulle-sde stash (checked out source) and built into the dependency folder. API docs and howtos are installed alongside dependencies. The AI can browse dependency source, demos, tests, and docs via `mulle-sde api`, `mulle-sde code`, and `mulle-sde howto` commands — it should use these to discover paths, never assume hardcoded locations.
- The skills must be self-contained — patterns.md and quirks.md carry all domain knowledge the user needs beyond what `mulle-sde api/howto` provides

## Pipeline

```
User describes what they want
    |
    +- Check PLAN.md (resume)
    +- Decompose into tasks → PLAN.md
    +- Scaffold if needed (mulle-sde init/add/reflect) → STRUCTURE.md + stubs
    |
    +- For each task:
    |   +- Select skill by work type (layer/widget/view/test/demo/foundation)
    |   +- Dispatch to appropriate subagent (isolated context)
    |   +- Executor: write .h/.m → compile → test → fix → report
    |   +- Mark done/replan, git commit
    |
    +- Summary
```

## Skill Architecture

### Philosophy: Skills as phase-aware context loaders

AGENTS.md is static — loaded once at session start, then buried as context grows. Secondary information gets weighted less and less. Skills solve this by being the active conductor: at each phase of work, the skill tells the executor exactly what to load *right now*. This keeps context fresh and relevant.

Each skill owns a specific type of work and knows:
- What phases that work involves
- What to load (mulle-sde commands + skill sub-files) at each phase
- What gotchas apply at each phase
- How to verify the result

mulle-sde commands are the instruments. The skill is the conductor that says "play this one now."

### Orchestrator

| Skill | Role |
|---|---|
| `mulleui-gen` | Decomposes request → selects skills → dispatches tasks → verifies |

Sub-files:
- `SKILL.md` — pipeline: decompose → scaffold (if needed) → dispatch → verify
- `decomposer.md` — task decomposition rules, skill selection logic

### Executor skills (one per work type)

| Skill | Work type | Example task |
|---|---|---|
| `mulle-layer` | Write a CALayer/CGGraphicsLayer subclass | "Create MulleRadialGaugeLayer with arc drawing" |
| `mulle-widget` | Write a UIControl + its layer + wire them | "Create UIRadialGauge widget" |
| `mulle-view` | Write a non-interactive UIView subclass | "Create UIBadgeView display-only view" |
| `mulle-test` | Write tests for an existing class | "Add trace-based tests for UIRadialGauge" |
| `mulle-demo` | Write a demo program for a widget | "Create main-uiradialgauge.m demo" |
| `mulle-foundation` | Write a non-UI class (model, utility) | "Create MulleColorPalette data class" |

Each skill is a separate subagent invocation with its own context.

### Why multiple skills instead of one

1. **Context efficiency** — `mulle-layer` loads drawing API docs; `mulle-test` loads testing howtos. Neither wastes context on the other's domain.
2. **Phase precision** — each skill's phases are specific to its work type. A layer skill has "design → draw method → hit testing → verify". A test skill has "study target class → write test → run → check golden file".
3. **Composability** — the orchestrator chains them: `mulle-widget` for the widget, then `mulle-test` for its tests, then `mulle-demo` for the demo. Each gets a fresh context with exactly the right loaded docs.
4. **Growable** — adding a new work type is just adding a new skill, not bloating an existing one.

### Skill internal structure

Each executor skill follows the same pattern:

```
skills/<name>/
    SKILL.md          — phased workflow, what to load at each phase
    patterns.md       — code patterns specific to this work type
    quirks.md         — gotchas, anti-patterns, "do this not that"
```

Example phased workflow (mulle-widget):

```
## Phase 1: Understand
- Run `mulle-sde api apropos "<terms>"` to find relevant APIs
- Run `mulle-sde code search "<pattern>"` to find similar implementations
- Read ${SKILL_DIR}/patterns.md

## Phase 2: Design
- Run `mulle-sde howto cat styleguide`
- Read ${SKILL_DIR}/quirks.md
- Read the project's UIWidget.md if it exists
- Plan the class hierarchy / file list

## Phase 3: Implement
- Run `mulle-sde api cat <Library>` for the specific APIs needed
- Run `mulle-sde add src/ClassName.m` to create stubs
- Write the implementation
- Run `mulle-sde reflect` after adding files

## Phase 4: Verify
- Run `mulle-sde craft` — check for compile errors
- Run `mulle-sde test run` (if tests exist)
- Read trace output / golden file comparison
- Fix and repeat
```

Each skill customizes the phases for its work type. `mulle-layer` emphasizes drawing API loading in phase 3. `mulle-test` emphasizes trace/event-replay patterns. `mulle-demo` emphasizes window setup and widget configuration.

### Orchestrator workflow example

```
User: "Create a radial gauge widget with tests and a demo"

mulleui-gen orchestrator:
  1. Decompose → 3 tasks:
     a. Widget (layer + view + wiring)  → @mulle-widget
     b. Tests for the widget            → @mulle-test
     c. Demo program                    → @mulle-demo
  2. Dispatch task (a) → @mulle-widget subagent
     → creates MulleRadialGaugeLayer.h/.m + UIRadialGauge.h/.m
  3. Dispatch task (b) → @mulle-test subagent
     → writes test/UIRadialGauge/01_initialization.m + .stdout
  4. Dispatch task (c) → @mulle-demo subagent
     → writes demo/src/main-uiradialgauge.m
  5. Final verify: mulle-sde craft + mulle-sde test run
```

### Agents (OpenCode)

| Agent | Skill | Mode |
|---|---|---|
| `mulleui-gen` | `mulleui-gen` | primary |
| `mulle-layer` | `mulle-layer` | subagent (hidden) |
| `mulle-widget` | `mulle-widget` | subagent (hidden) |
| `mulle-view` | `mulle-view` | subagent (hidden) |
| `mulle-test` | `mulle-test` | subagent (hidden) |
| `mulle-demo` | `mulle-demo` | subagent (hidden) |
| `mulle-foundation` | `mulle-foundation` | subagent (hidden) |

### Other files

| File | Action |
|---|---|
| `AGENTS.md` | Rewrite — MulleUI project structure description |
| `opencode.json` | Keep as-is (permissions are generic) |
| `publish_mulleui.sh` | New — publishes skills + agents to target project |

## Document Protocol (unchanged pattern)

| Document | Purpose |
|---|---|
| `PLAN.md` | Task DAG — Goal/Requirements/Verify/Status per task |
| `STRUCTURE.md` | Architecture: class hierarchy, files, dependencies, delegate/protocol contracts |
| `MEMORY.md` | Accumulated discoveries from task execution |
| `reference.png` | (Optional) Widget mockup image |

## Verification Loop

Two-layer verification: trace-based for logic, visual QA for polish.

### Layer 1: Trace-Based Verification (primary)

MulleUI has a trace facility that prints drawing commands as text. The LLM can verify correctness directly from trace output — no vision model needed.

Additionally, there is an **event replay system** that can simulate user input (clicks, button presses). This means tests can exercise interactive behavior — not just "does it draw correctly" but "does clicking the button trigger the right action."

```
Write .h/.m
    → mulle-sde craft
    → mulle-sde test run path/to/test.m
        (test uses event replay to simulate clicks/input)
        (test enables trace to capture drawing commands)
    → Check .tmp.stdout against .stdout golden file (exit 0 = pass)
    → Read trace output: "fillCircle center=10,20 radius=5 color=0x0000FF"
    → LLM verifies: is a blue circle really drawn at 10,20? Correct.
    → Fix if wrong, recompile, retest
```

This is cheaper, faster, and more deterministic than Godogen's screenshot + Gemini vision approach. The trace output is parseable text — the LLM can reason about it directly without a vision model. The event replay closes the loop on interactivity — something Godogen could only test visually.

### Layer 2: Visual QA (optional, final polish)

MulleCG can render to framebuffers and write PNGs headlessly. For a final visual check, capture a screenshot and either:
- Have the LLM read the image directly (if the model supports vision)
- Use Gemini Flash vision (same as Godogen)

This catches things trace can't: anti-aliasing quality, color blending, visual balance, overlapping elements. But it's optional — trace verification handles the logic.

### Key commands (confirmed + new)

| Purpose | Command |
|---|---|
| Compile project | `mulle-sde craft` |
| Run single test | `mulle-sde test run path/to/test.m` |
| Run all tests | `mulle-sde test run` |
| Check compiler errors | `cat path/to/test.tmp.ccerr` |
| Check test output | `cat path/to/test.tmp.stdout` |
| Check runtime errors | `cat path/to/test.tmp.stderr` |
| Enable trace output | `[btn setDrawCallTracer:stdout]` on the layer/view |
| Enable debug flags | `[btn setDebuggingFlags:0x7]` (UIControlDebug\|Verbose\|Event) |
| Event replay (programmatic) | Create `UIMouseButtonEvent`, call `[btn mouseDown:event]` etc. |
| Event replay (scripted) | `UIEventPlayer` with `loadScriptFromUTF8String:` — `"0.05 mouseDown button=Left x=60 y=35\n"` |
| Window style for headless | `UIWindowStyleNoDrawing\|UIWindowStyleClearType` |
| Trace via window style | `UIWindowStyleTraceDrawCalls` (set in styleMask) |
| Capture screenshot | TBD — framebuffer → PNG |

## Files to Write by Hand (domain expertise required)

### 1. `quirks.md` — accumulated debugging knowledge

The only file that truly requires hand-written domain expertise:

- mulle-objc vs Apple ObjC differences (the "looks like Python but isn't" problem)
- Memory management traps specific to mulle-objc
- Known compiler warnings that are benign
- Layout system gotchas
- Event handling order
- Initialization patterns that differ from UIKit
- Import/include conventions (`#import <Project/Project.h>` vs `#include "include.h"`)
- Things `mulle-sde howto` doesn't cover

### 2. `patterns.md` — common widget implementation patterns

Example-driven file showing:
- How to create a new class (.h + .m pair)
- How to implement a protocol
- How to add a category
- How to write a test
- Common widget patterns (drawing, layout, event handling)

Can be partially bootstrapped from the 60+ demo files in MulleCG.

### 3. `mulle-sde-reference.md` — command quick reference for the executor

Condensed version of what we learned above — which mulle-sde commands to use when. This is mechanical to write from the howto output.

### 4. Scaffold stage

In the multi-skill model, scaffolding is handled by the orchestrator (`mulleui-gen`) directly — it's lightweight enough that it doesn't need its own skill:

1. `mulle-sde init` (new projects only — user may already have a project)
2. `mulle-sde dependency add` (if the target project doesn't already depend on the needed MulleUI libraries)
3. `mulle-sde add src/ClassName.m` for each planned class (creates .h/.m pairs with `@interface` boilerplate)
4. `mulle-sde reflect`
5. Write `STRUCTURE.md` — class hierarchy plan shared with all task executors

For existing projects, steps 1-2 are often skipped. The orchestrator should check what's already there.

## Decomposer: What's "Hard" vs "Routine" for MulleUI

### Hard (isolate into own task)
- Custom drawing/rendering (CoreGraphics-equivalent)
- Complex gesture recognizer chains
- Animation systems
- Custom layout logic
- Interaction with low-level runtime features

### Routine (bundle together)
- Standard property accessors
- Simple event forwarding (target/action)
- Basic subview management (addSubview, removeFromSuperview)
- Standard init/dealloc patterns
- Delegate protocol conformance
- Basic Auto Layout constraints (if applicable)

## mulle-sde: What We Learned

mulle-sde is explicitly designed to be AI-friendly. It provides structured access to everything a code generator needs.

### Build Commands (answered)

| Purpose | Command |
|---|---|
| Compile project | `mulle-sde craft` |
| Clean rebuild | `mulle-sde craft -g` |
| Update build files after adding/removing sources | `mulle-sde reflect` |
| Run all tests | `mulle-sde test run` |
| Run single test | `mulle-sde test run path/to/filename` |
| Retest (refetch deps) | `mulle-sde retest` |
| Add a source file | `mulle-sde add` |
| Add dependency | `mulle-sde dependency add github:user/repo` |
| Add system library | `mulle-sde library add pthread` |
| Project overview | `mulle-sde view` |
| List project files | `mulle-sde list` |

**Critical rule**: The `test/` directory is an ISOLATED mulle-sde project. Never run `mulle-sde craft` to affect tests — use `mulle-sde test run` instead.

### API Documentation (answered — this is huge)

mulle-sde has a built-in `api` command that serves AI-friendly documentation:

| Command | Purpose |
|---|---|
| `mulle-sde api list [--all]` | List available API docs from dependencies |
| `mulle-sde api cat <name>` | Show full API doc for a dependency |
| `mulle-sde api apropos "query"` | Keyword search through all API docs |
| `mulle-sde api context` | Dump ALL API docs to stdout (pipe to AI) |

This **replaces the entire `doc_api/` directory and `ensure_doc_api.sh` tooling** from Godogen. Instead of converting XML/headers to markdown, we just call `mulle-sde api cat <name>`. The docs are already AI-formatted markdown with class interfaces, methods, properties, and usage patterns.

Available API docs for MulleCG include: MulleObjC, MulleUIBase, mulle-gfx, mulle-container, mulle-allocator, mulle-concurrent, mulle-thread, and ~30 more.

### Code Navigation (answered — also huge)

mulle-sde has a `code` command with roam integration:

| Command | Purpose |
|---|---|
| `mulle-sde code map` | Project skeleton with symbols, clusters, entry points |
| `mulle-sde code understand` | AI overview of project |
| `mulle-sde code grep "pattern"` | Fast text search across project + deps |
| `mulle-sde code grep --declarations "func"` | Find declarations only |
| `mulle-sde code search <symbol>` | Semantic symbol search |
| `mulle-sde code callers <symbol>` | Who calls this? |
| `mulle-sde code callees <symbol>` | What does this call? |
| `mulle-sde code preflight <symbol>` | Impact analysis before modifying |
| `mulle-sde code symbol --functions` | List all functions |
| `mulle-sde code symbol --interfaces` | List all ObjC interfaces |
| `mulle-sde code find header <file>` | Locate a header file |

### Howto System (answered)

mulle-sde has built-in howtos that serve as domain knowledge:

| Howto | Content |
|---|---|
| `mulle-sde howto styleguide` | Coding style (Allman braces, 3-space indent, C89 declarations) |
| `mulle-sde howto mulle-c-syntax` | Naming conventions for structs, functions, verbs, objects |
| `mulle-sde howto craft` | Build system guidelines |
| `mulle-sde howto testing` | Test creation, running, verification patterns |
| `mulle-sde howto navigation` | Code navigation quick reference |
| `mulle-sde howto dependency` | Managing dependencies |
| `mulle-sde howto debug` | Debugging, crash analysis |

### Project Layout (answered)

```
src/                    # Source files (.h, .m)
src/reflect/            # Auto-generated headers (mulle-sde reflect)
src/generic/            # Generic include/import headers
test/                   # ISOLATED mulle-sde project for tests
  10-first/             # Test themes (numbered directories)
  40-gradient/
  *.m                   # Test source (plain C/ObjC with main())
  *.stdout              # Expected output (golden file)
  *.tmp.stdout         # Actual output (generated by test run)
  *.tmp.ccerr          # Compiler warnings/errors
cmake/                  # Build system files (managed by mulle-sde)
.mulle/                 # mulle-sde project config
CMakeLists.txt          # Top-level (managed by mulle-sde)
```

### Test Pattern (answered)

Tests are plain C/ObjC programs with `main()`. Verification is output-based — compare stdout to `.stdout` golden file:

```objc
#import <MulleCG/MulleCG.h>

int   main( int argc, char *argv[])
{
   CGFramebuffer   *layer;

   layer = [CGFramebuffer new];
   [layer release];
   return( 0);
}
```

- `#import` the project header (or `#include "include.h"` for deps)
- Return 0 for success
- Use `mulle_printf` or `printf` for output
- Never print addresses, times, or non-deterministic values
- Create `.stdout` golden file with expected output
- Run with `mulle-sde test run path/to/test.m`

### Screenshot Capture (partially answered)

MulleCG has `demo/` programs that render to framebuffers and can write PNGs (see `main-cgimage-write.m`, `main-framebuffer-simple.m`, `main-draw-simple.m`). The `mulleui-debug.m` has `MulleUIWriteImageToPNGFileSequence()`. So headless rendering + PNG capture IS possible — visual QA could work.

## Scale and Scope

### The MulleUI ecosystem

MulleUI is not a single project — it's a multi-project framework with ~30+ active libraries:

**Core rendering stack:**
- `MulleCG` — CoreGraphics-like 2D drawing (CGContext, CGPath, CGColor, etc.)
- `MulleCGNanoVG` — NanoVG backend for MulleCG
- `MulleCA` — CoreAnimation-like layer system (CALayer, CATextLayer, etc.)
- `MulleGraphics` / `MulleGraphicsImage` — image handling, graphics primitives

**UI framework:**
- `MulleUIBase` — base UI types
- `MulleUIFoundation` — foundation-level UI support
- `MulleUIView` — UIView hierarchy
- `MulleUIWindow` — window management
- `MulleUIApplication` — application lifecycle
- `MulleUIWidgets` — interactive controls (UIButton, UISlider, UILabel, UITextField, UIScrollView, UISwitch, UIStepper, UISegmentedControl, MullePopUpButton, MulleMenu, UISpinner, UICycleButton, UIStackView, UIGridView, etc.)
- `MulleNSTableView` — table view

**Platform/windowing:**
- `MulleGLFW` — GLFW windowing backend
- `MulleSDL` — SDL backend
- `MulleUIOS` — iOS-like abstractions

**Media:**
- `MulleImage` / `MulleUIImage` — image loading/display
- `MulleAudio` / `MulleVideo` — audio/video
- `MullePDF` — PDF rendering

### What the generator needs to handle

The generator works in the user's target mulle-sde project. Typical scenarios:

1. **Add a widget to an existing library** (e.g., MulleUIWidgets) — new UIControl subclass with layer, tests, demo
2. **Build a standalone app** — `mulle-sde init` a new project, add MulleUI dependencies, create window + widget hierarchy + event handling
3. **Add a non-UI class** — model objects, utilities, data structures in any mulle-sde project
4. **Work across multiple subprojects** — e.g., add a new layer type in MulleCG, then use it in MulleUIWidgets. Expert-level, may need user guidance.

The common case is (1) and (2). The generator should ask the user where the target project is if not obvious from the working directory.

### Accessing MulleUI source and docs

MulleUI dependency source lives in the mulle-sde stash and is built into the dependency folder. The AI accesses everything through mulle-sde commands:

- `mulle-sde api cat MulleCG` — API docs for any dependency
- `mulle-sde api apropos "draw circle"` — search across all dependency APIs
- `mulle-sde howto list` / `mulle-sde howto cat <topic>` — installed howtos
- `mulle-sde code search "drawInContext"` — find implementations in project + deps
- `mulle-sde code map` — project structure overview

MulleUI subprojects also ship additional docs (WIDGETS-HOWTO.md, UIWidget.md, ACCESSOR-PATTERNS.md, demo programs, tests with golden files). These are discoverable via the stash — the AI should use mulle-sde to locate them, not assume hardcoded paths.

### Implications for the generator

1. **mulle-sde is the universal interface** — API docs, howtos, code navigation, build commands, dependency source — all accessible through mulle-sde regardless of project setup.
2. **Skills are self-contained but not isolated** — patterns.md and quirks.md carry essential domain knowledge, but the AI should also pull from mulle-sde api/howto/code at each phase.
3. **The skill's job is phased orchestration** — load the right context at the right time, not front-load everything.

## Remaining Open Questions

1. **Screenshot capture** — What's the minimal code to render headlessly and write a PNG? (For optional visual QA layer)
2. **Cross-project tasks** — Should the generator handle tasks that span multiple mulle-sde projects, or is that out of scope?
3. **Project discovery** — How does the orchestrator determine what kind of project it's in? (Library vs app, what MulleUI deps are available, does AGENTS.md exist?) Probably just `mulle-sde view` + check for known files.

## When to Add a New Executor Skill vs. Extend an Existing One

### Add a new skill when:

1. **The work type needs different context.** If the phase 3 (implement) of the new work loads fundamentally different APIs/docs than any existing skill, it deserves its own skill. Example: `mulle-layer` loads MulleCG drawing APIs; `mulle-test` loads testing howtos and trace patterns. Completely different context needs → separate skills.

2. **The phases themselves differ.** A layer skill's phases are: design shape → implement drawInContext → verify trace output. A demo skill's phases are: pick widget → set up window → configure widget → run. Different workflow → separate skill.

3. **Combining would bloat context.** If you'd need to add "if you're doing X, skip this section" conditionals to the SKILL.md, that's a sign the skill is trying to serve two masters. Split it.

### Extend an existing skill when:

1. **Same phases, different content.** If the new work follows the same workflow but just needs an extra pattern in `patterns.md` or an extra gotcha in `quirks.md`, add to the existing skill's sub-files.

2. **The new work is a variant, not a new type.** Example: writing a UIScrollView subclass is still `mulle-widget` work — it's a more complex widget, but the phases (design → implement layer → implement view → wire events → verify) are the same. Add scrollview-specific patterns to `mulle-widget/patterns.md`.

3. **The context overlap is >80%.** If the new work would load mostly the same APIs and docs as an existing skill, folding it in avoids duplicating skill infrastructure for marginal benefit.

### Decision checklist

```
Does the new work need different APIs loaded in phase 3?
  YES → new skill
  NO  ↓

Does the new work have a different phase sequence?
  YES → new skill
  NO  ↓

Would adding it to an existing skill require conditional logic in SKILL.md?
  YES → new skill
  NO  → extend existing skill (add to patterns.md / quirks.md)
```

### Example decisions

| Work type | Decision | Reasoning |
|---|---|---|
| UITableView subclass | Extend `mulle-widget` | Same phases as any widget, just more complex patterns |
| Animation system | **New skill** `mulle-animation` | Different APIs (CAAnimation), different phases (keyframe design → timing → interpolation) |
| Accessibility support | Extend `mulle-widget` | Adds to existing widget implementation, same phases |
| Audio integration | **New skill** `mulle-audio` | Completely different APIs (MulleAudio), different verification (listen vs. trace) |
| ScrollView with custom physics | Extend `mulle-widget` | Complex but still widget phases; add physics patterns to patterns.md |
| NIB/serialization support | **New skill** `mulle-nib` | Different workflow entirely (define format → serialize → deserialize → verify roundtrip) |
