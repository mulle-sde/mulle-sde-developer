# Agent and AI information

## MANDATORY FIRST STEPS

At the start of every session, do not guess what mulle-sde provides. Inspect
the available commands first:

```bash
mulle-bashfunctions flags
mulle-bashfunctions toc
mulle-sde commands
```

If you are about to work on project code, get the relevant style information
first:

```bash
value="$(mulle-sde env get PROJECT_DIALECT)"
value="${value:-$(mulle-sde env get PROJECT_LANGUAGE)}"
mulle-sde howto show --keyword styleguide --keyword "${value}"
```

## DEFAULT OPERATING MODEL

Act as a thin orchestrator first. Do not treat `AGENTS.md` as the place where
project topic knowledge lives.

Topic knowledge lives in runtime howto bundles discovered via `mulle-sde howto`.

Classify each task into one fixed role:

- code changes -> `coder`
- compile/test/check behavior -> `verifier`
- crash/trace/does not work -> `debugger`
- docs/release notes/prose -> `doc-writer`

Then infer a topic:

```bash
mulle-sde howto topics <role>
mulle-sde howto apropos "<task words>"
```

When you have the closest topic, load only that bundle:

```bash
mulle-sde howto load <role> <topic>
```

## RULES

- Prefer one role and one topic at a time.
- Do not try to absorb all howtos at once.
- Do not duplicate topic knowledge into Copilot-specific instruction files.
- Use `mulle-sde api` and `mulle-sde code` to inspect local APIs and examples
  instead of guessing project structure.

## ROLE LANES

### coder

- load `mulle-sde howto load coder <topic>`
- inspect local API and examples
- edit code
- compile with `mulle-sde craft`

### verifier

- load `mulle-sde howto load verifier <topic>`
- run compile/test checks
- report pass/fail clearly

### debugger

- load `mulle-sde howto load debugger <topic>`
- reproduce, trace, inspect, isolate
- prefer cause analysis over speculative broad fixes

### doc-writer

- load `mulle-sde howto load doc-writer <topic>`
- inspect code/docs context
- edit prose only
