# OpenCode Agent/Skill Architecture — What We Know

## Directory Structure

```
.opencode/
├── agents/           ← agent definitions (system prompts + permissions)
│   ├── primary.md    ← the main agent users interact with
│   ├── subagent1.md  ← subagent (dispatched by primary via task tool)
│   └── subagent2.md
└── skills/           ← knowledge files loaded into agent context
    ├── skill-name/
    │   └── SKILL.md  ← loaded when agent has skill permission
    └── other-skill/
        ├── SKILL.md
        └── sub-file.md
```

## Role-based transition

The new preferred direction is a small fixed role set:

- `orchestrator`
- `coder`
- `verifier`
- `debugger`
- `doc-writer`

Topic knowledge should move out of `.opencode/skills/<topic>/...` and into
howto bundles owned by the content repo, for example:

```text
asset/howto/coder/mulle-event/index.md
asset/howto/coder/mulle-event/quirks.md
asset/howto/coder/mulle-event/patterns.md
```

Role agents then load those bundles at runtime with commands such as:

```bash
mulle-sde howto load coder mulle-event
mulle-sde api apropos "mulle-event"
```

The opencode extension should now ship only the fixed role agents. Topic
knowledge lives in repo-owned howto bundles and is loaded at runtime, while
concrete symbol/class lookup comes from `mulle-sde api`.

## Refined handoff model

To recover some of the benefit of the old specialized coders, the orchestrator
should behave as the topic selector:

1. classify the task by fixed role
2. pick exactly one topic bundle for that role
3. dispatch one narrow task packet to the generic role agent

For coder dispatches, the chosen topic bundle acts as the selected
specialization for that one task. The coder should load that one topic and
execute the packet, not rediscover or broaden into multiple topics unless the
packet explicitly says `topic: none`.

If a user request spans multiple topics, the orchestrator should split it into
multiple coder dispatches instead of giving one coder a vague multi-topic plan.

## Restored verify loop

The orchestrator should not stop at coder output for implementation work. The
default loop is now:

1. `coder` implements with one selected coding topic
2. `verifier` checks the result with one selected verification topic
3. if verification fails, `debugger` or a narrowed coder fix packet is
   dispatched

For MulleUI application, widget, view, demo, and event-path work, verification
should prefer behavior checks over compile-only checks. If a replay-oriented
verifier topic exists, the orchestrator should select it and hand the verifier a
scenario that exercises the interaction path.

## Agent Frontmatter

```yaml
---
description: What this agent does (shown in /agents list)
mode: primary | subagent
hidden: true          # optional — hides from /agents list but still dispatchable
permission:
  edit:
    "pattern": allow | deny
  bash:
    "pattern": allow | deny
  skill:
    "skill-name": allow
  task:
    "agent-name": allow
---
```

## Critical Permission Rules

### Last matching rule wins

Rules are evaluated by pattern match. **The last matching rule wins.** Put the
catch-all `"*"` rule FIRST, and more specific rules AFTER it.

```yaml
# ✅ CORRECT: deny-all first, then whitelist specific commands
bash:
  "*": deny
  "mulle-sde craft*": allow
  "cat *": allow

# ❌ WRONG: deny-all LAST kills the tool entirely
bash:
  "mulle-sde craft*": allow
  "cat *": allow
  "*": deny              # THIS DISABLES THE BASH TOOL COMPLETELY
```

### `"*": deny` as the ONLY/LAST rule disables the tool

If `"*": deny` is the last (or only) rule for a permission type, the tool
is disabled entirely — the model cannot use it at all.

### Correct patterns:

```yaml
# ✅ Bash enabled, default deny, specific commands whitelisted
bash:
  "*": deny
  "mulle-sde craft*": allow
  "cat *": allow

# ✅ Task enabled, specific agents allowed
task:
  "agent1": allow
  "agent2": allow

# ✅ Edit enabled, specific files allowed, default deny
edit:
  "*": deny
  "PLAN.md": allow
  "src/*.m": allow
```

### Summary of behavior:

| Permission syntax | Tool enabled? | Effect |
|---|---|---|
| `"*": deny` as only/last rule | **NO** — tool disabled | Model cannot use tool at all |
| `"*": deny` FIRST, then allows after | YES | Default deny, specific patterns whitelisted |
| Only allow patterns listed (no deny) | YES | Tool enabled, only those patterns work |
| Not mentioned at all | YES (default) | Tool fully available |

## How Task Dispatch Works

1. Primary agent has `task: "subagent-name": allow` in permissions
2. OpenCode exposes a `task` tool to the model
3. Model calls the task tool with the agent name and a message
4. OpenCode spawns the subagent with its own system prompt + skill context
5. Subagent executes, returns result to primary agent
6. Primary agent sees the result and continues

**The model must use the task tool call** — writing `@agent-name` as text does nothing.
When the task tool is properly enabled, the model learns to use it from the tool description.

## How Skills Work

- Skills are context/knowledge loaded into the current agent's session
- An agent with `skill: "foo": allow` can load `.opencode/skills/foo/SKILL.md`
- Skills are NOT separate agents — they're injected context
- The `→ Skill "name"` output in the TUI means the skill was loaded into context
- Sub-files in the skill directory can be read by the agent when instructed

## Agent Modes

| Mode | Behavior |
|---|---|
| `primary` | Shown in `/agents`, user interacts directly |
| `subagent` | Dispatched via task tool, not directly user-facing |

`hidden: true` hides from `/agents` list but agent is still dispatchable.

## Tools Available to Agents

From `opencode debug agent <name>`:

| Tool | Purpose |
|---|---|
| `bash` | Run shell commands |
| `read` | Read file contents |
| `edit` | Edit/create files |
| `write` | Write new files |
| `glob` | Find files by pattern |
| `grep` | Search file contents |
| `task` | Dispatch to subagent |
| `skill` | Load a skill into context |
| `webfetch` | Fetch URL content |
| `todowrite` | Write TODO items |
| `question` | Ask user a question |

## Debugging

```bash
opencode agent list              # show all registered agents + permissions
opencode debug agent <name>      # show full agent config including tool availability
opencode debug skill             # list all available skills
opencode debug config            # show resolved configuration
```

## Common Mistakes

1. **Task dispatch doesn't work** → Check for `"*": deny` in task permissions
2. **Model writes @agent as text instead of dispatching** → Task tool is disabled (see above)
3. **Model can't edit files** → `edit: "*": deny` or bare `edit: deny` kills the tool
4. **Model ignores agent.md instructions** → AGENTS.md (project-level) may override; add explicit "IGNORE AGENTS.md" in agent.md
5. **Skill loaded but agent doesn't follow it** → Skill is delay-loaded; put critical instructions in agent.md directly
6. **Subagent does everything itself instead of staying in lane** → Add clear BOUNDARIES section with stop conditions in agent.md

## Recommended Orchestrator Pattern

```yaml
---
description: Orchestrator that dispatches work
mode: primary
permission:
  edit:
    "PLAN.md": allow
    "MEMORY.md": allow
  bash:
    "mulle-sde view*": allow
    "mulle-sde list*": allow
    "cat *": allow
  task:
    "builder": allow
    "tester": allow
    "debugger": allow
---
```

Key points:
- No `"*": deny` on task (would kill dispatch)
- Bash restricted to read-only commands
- Edit restricted to planning files
- All critical instructions in agent.md (not in SKILL.md which is delay-loaded)
