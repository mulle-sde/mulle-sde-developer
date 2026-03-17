---
name: mulleui-gen
description: |
  Generate or update mulle-objc code in a mulle-sde project that uses MulleUI. Use when asked to create a widget, view, layer, demo, test, or app using MulleUI.
---

# MulleUI Generator — Orchestrator

Generate mulle-objc widgets, views, layers, tests, demos, and apps in any mulle-sde project.

## Sub-files

Read from `.opencode/skills/mulleui-gen/` when you reach the relevant stage:

| File | When to read |
|------|-------------|
| `decomposer.md` | Before writing PLAN.md |

## Pipeline

```
User request
    |
    +- Check "no review" in request → set REVIEW=off in PLAN.md header, else REVIEW=on
    +- Check PLAN.md (resume: read PLAN.md + STRUCTURE.md + MEMORY.md, skip to task loop)
    |
    +- Orient: run `mulle-sde view` + `mulle-sde list` to understand the target project
    +- Read decomposer.md → decompose into tasks → write PLAN.md
    +- Scaffold if needed → write STRUCTURE.md + stubs
    +- Show user: task list summary
    |
    +- While pending tasks exist:
    |   +- Mark task in_progress in PLAN.md
    |   +- Dispatch to appropriate subagent (see skill selection below)
    |   +- If REVIEW=on: dispatch to @mulle-reviewer with the task's target files
    |       +- PASS → mark done, commit
    |       +- ISSUES → re-dispatch task with reviewer feedback appended, max 2 retries
    |   +- If REVIEW=off: mark done, commit
    |
    +- Final: mulle-sde craft + mulle-sde test run → confirm clean
    +- Summary
```

## Skill Selection

Dispatch each task to the subagent matching its work type:

| Work type | Subagent | Trigger |
|---|---|---|
| CALayer/CGGraphicsLayer subclass | `@mulle-layer` | task involves custom drawing layer |
| UIControl + layer + wiring | `@mulle-widget` | task involves interactive control |
| Display-only UIView | `@mulle-view` | task involves non-interactive view |
| Tests | `@mulle-test` | task involves writing/updating tests |
| Demo program | `@mulle-demo` | task involves demo/main-*.m |
| Non-UI class | `@mulle-foundation` | task involves model/utility/data class |

## Dispatching Tasks

**You MUST use the Task tool to dispatch to subagents.** Do NOT write the task block as text — invoke the Task tool with the subagent name and the task block as the message. The subagent runs in its own isolated session.

Example — dispatching to the mulle-widget subagent:

Use the Task tool with:
- agent: `mulle-widget`
- message: the full task block from PLAN.md

```
## N. {Task Name}
- **Status:** in_progress
- **Skill:** mulle-widget
- **Targets:** src/UIFoo.h, src/UIFoo.m, src/MulleFooLayer.h, src/MulleFooLayer.m
- **Goal:** ...
- **Requirements:** ...
- **Verify:** mulle-sde craft passes; mulle-sde test run passes
```

The subagent loads its own skill and executes the task autonomously. It writes the actual code. **You (the orchestrator) MUST NOT write implementation code yourself.**

## Scaffold

Run before dispatching tasks when the project needs new files:

```bash
mulle-sde add src/ClassName.m   # creates .h + .m with @interface boilerplate
mulle-sde reflect               # update build files
```

For new projects: `mulle-sde init` first, then `mulle-sde dependency add` for needed MulleUI libraries.

## Recovery

- **Compile failure after task** — read `.test.ccerr` or craft output, replan or re-dispatch
- **Test failure** — re-dispatch to `@mulle-test` with failure details
- **Wrong architecture** — rewrite STRUCTURE.md, re-scaffold, replan

## Memory

Write `MEMORY.md` with discoveries: workarounds found, APIs that behaved unexpectedly, patterns that worked well. Read it at resume time.
