# Task Decomposer

Break the user's request into a PLAN.md task list, selecting the right skill for each task.

## Step 1: Classify the request

| Request type | Typical task sequence |
|---|---|
| New interactive widget | layer → widget → test → demo |
| New display-only view | view → test → demo |
| New foundation class | foundation → test |
| New demo only | demo |
| New tests only | test |
| Standalone app | foundation (models) → layer (if custom drawing) → widget/view → demo (app entry point) |

## Step 2: Identify dependencies

Tasks that depend on others must be ordered. A widget task depends on its layer task. A test task depends on the class it tests. A demo task depends on the widget/view it demonstrates.

Mark dependencies in PLAN.md with `**Deps:** N` where N is the task number.

## Step 3: Write PLAN.md

Set `review: on` unless the user said "no review" or similar — then set `review: off`.

```markdown
# PLAN
review: on

## 1. {Task Name}
- **Status:** pending
- **Skill:** mulle-layer | mulle-widget | mulle-view | mulle-test | mulle-demo | mulle-foundation
- **Targets:** src/Foo.h, src/Foo.m
- **Goal:** one sentence
- **Requirements:** bullet list of specifics
- **Verify:** what mulle-sde craft + test run should show
- **Deps:** (none) | 1, 2
```

## Step 4: Write STRUCTURE.md

```markdown
# STRUCTURE

## Classes
| Class | Type | File | Inherits |
|---|---|---|---|
| MulleFooLayer | CGGraphicsLayer | src/MulleFooLayer.h/.m | CGGraphicsLayer |
| UIFoo | UIControl | src/UIFoo.h/.m | UIControl |

## Dependencies
- UIFoo owns a MulleFooLayer (its rendering layer)
- UIFoo forwards visual properties to MulleFooLayer

## Files
src/MulleFooLayer.h, src/MulleFooLayer.m
src/UIFoo.h, src/UIFoo.m
test/UIFoo/01_init.m, test/UIFoo/01_init.stdout
demo/src/main-uifoo.m  (if demo requested)
```

## Sizing tasks

Keep tasks small enough that one subagent can complete them in one context window. If a widget is complex (many states, complex drawing, multiple event types), split layer and widget into separate tasks. If simple, combine them into one widget task.

Don't split tests from their class unless the class already exists and tests are being added later.
