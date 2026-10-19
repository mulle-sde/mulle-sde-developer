# mulle-sde Build System Guidelines
<!-- Keywords: craft, build, run, check -->

mulle-sde manages the build from beginning to end. Do not run `cmake` or edit
build system files manually unless absolutely necessary.

## Core commands

```bash
mulle-sde check                                    # fast syntax/type check (no link)
mulle-sde reflect
mulle-sde craft
mulle-sde craft -g
mulle-sde -DCFLAGS="-DSOME_FLAG=value" craft --clean
```

## Workflow

Use `mulle-sde check` after editing source files to catch type errors
instantly (~0.7s). Only run `mulle-sde craft` when you need a full build
with linking (e.g. before `mulle-sde run` or `mulle-sde test`).

## Compiler and flag overrides

mulle-sde does **not** inherit `CC`, `CXX`, `CFLAGS`, `LDFLAGS`, ... from the
calling shell. It rebuilds the environment from the project scope files
(`mulle-env` uses `env -i`), so prefix assignments are discarded without any
warning:

```bash
CC=tcc mulle-sde craft        # WRONG: CC never reaches the compiler
CC=tcc mulle-sde test craft   # WRONG: same, even inside the test project
```

Use a definition instead. `-D` is a one-time override that survives nested
environments such as `test`:

```bash
mulle-sde -DCC=tcc craft
mulle-sde -DCC=tcc test craft
mulle-sde -DCFLAGS="-DMY_FLAG=1" craft
```

Persist it for the project, or use the test-specific shortcut:

```bash
mulle-sde definition set --clobber CC tcc     # project scope
mulle-sde test craft --cc tcc                 # option comes AFTER the command
```

After switching compilers, rebuild from scratch (`mulle-sde craft --clean` or
`mulle-sde test clean all`). mulle-make skips `cmake` when no cmake files
changed, so the old compiler stays in the build directory otherwise.

## Build rules

- do not add sources to build files by hand
- add dependencies with `mulle-sde dependency`
- add libraries with `mulle-sde library`
- missing header → likely `dependency add`
- missing symbol → likely `library add`

## Troubleshooting

```bash
mulle-sde library add <name>
mulle-sde dependency add github:<user>/<repo>
mulle-sde reflect && mulle-sde craft
```
