# mulleui-gen


*** THIS LIVES NOW IN MULLE_SDE_DEVELOPER!! ****

AI-powered code generator for [MulleUI](https://github.com/nicotine-lmth/MulleUI) widgets and views. Runs inside [OpenCode](https://github.com/nicotine-lmth/opencode) as a multi-agent pipeline.



## What it does

You describe a widget in plain English. The orchestrator decomposes it into typed tasks (layer, view, widget, test, demo), dispatches each to a specialized executor agent, and optionally runs a reviewer pass. All generated code follows MulleUI conventions — `char *` strings, `CGColor` values, `drawInContext:` drawing, two-layer widget architecture.

## Requirements

- A [mulle-sde](https://mulle-sde.github.io/) project that depends on MulleUI
- [OpenCode](https://github.com/nicotine-lmth/opencode) installed
- An LLM provider (Sonnet 4+ recommended; GPT-4.1 doesn't follow skills)

## Install

```bash
./publish_mulleui.sh /path/to/your/mulle-sde-project
```

This copies agents and skills into `.opencode/` and creates `opencode.json`. It won't overwrite an existing `AGENTS.md`.

## Usage

```bash
cd /path/to/your/mulle-sde-project
opencode run --agent mulleui-gen "Create a UIProgressBar widget with a fill color property"
```

Add "no review" to skip the reviewer step:

```bash
opencode run --agent mulleui-gen "Create a UIToggle switch, no review"
```

## Architecture

```
mulleui-gen (orchestrator)
├── mulle-layer      — CALayer / CGGraphicsLayer subclasses
├── mulle-widget     — UIControl + layer + event wiring
├── mulle-view       — display-only UIView subclasses
├── mulle-test       — golden-file tests with trace verification
├── mulle-demo       — demo programs (main-*.m)
├── mulle-foundation — non-UI mulle-objc classes
└── mulle-reviewer   — read-only code review (PASS / ISSUES)
```

Each executor follows a 4-phase workflow: understand → design → implement → verify. Skills load API docs dynamically via `mulle-sde api cat` at each phase.

## Files

| Path | Purpose |
|------|---------|
| `mulleui/agents/*.md` | Agent definitions (8 agents) |
| `mulleui/skills/*/SKILL.md` | Phased workflows per work type |
| `mulleui/skills/*/patterns.md` | Code skeletons |
| `mulleui/skills/shared/quirks.md` | MulleUI API rules (copied to each skill) |
| `mulleui/AGENTS.md` | Baseline project rules |
| `publish_mulleui.sh` | Deploys to target project |
| `MATCHPLAN.md` | Design document |

## License

See [LICENSE.md](LICENSE.md).
