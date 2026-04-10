# Agent and AI information

## MANDATORY FIRST STEPS

Run these at the start of every session:

```bash
mulle-sde vibecoding on
mulle-sde commands
mulle-sde api list
mulle-sde howto list
```

## Project context

This is a mulle-sde project. Use `mulle-sde` commands for everything — build, test, API lookup, code navigation. Do not edit `cmake/share/` or `cmake/reflect/` — they are managed by mulle-sde.

```bash
mulle-sde view          # project overview
mulle-sde list          # source files
mulle-sde code map      # symbol map
mulle-sde lsp           # emit a lsp.json for supported languages
```

## Build

```bash
mulle-sde craft                        # compile
mulle-sde test run                     # run all tests
mulle-sde test run test/Foo/01_init.m  # run one test
mulle-sde reflect                      # update build after adding/removing files
mulle-sde add src/Foo.m                # add new class (creates .h + .m)
```

**Critical:** `test/` is an isolated mulle-sde project. Never use `mulle-sde craft` for tests.

## mulle-objc rules

- No dot syntax: `[self foo]` not `self.foo`
- No blocks (`^`), no `__bridge`, no `@synthesize`, no `@import`
- Use `BOOL`/`YES`/`NO` not `bool`/`true`/`false`
- No `atomic`/`weak`/`strong`
- Instance variables only in `@interface`, never in `@implementation`
- `char *` string properties must be named `*UTF8String`
- No Foundation classes in headers — use `char *`, `struct mulle_array`, `CGColor`
- Event handlers return `UIInputEvent *`, not `void`

## DO NOT

- `git revert`, `git checkout` files, or any destructive git command
- Edit `cmake/share/` or `cmake/reflect/`
- Fix build system issues with anything other than `mulle-sde` commands
