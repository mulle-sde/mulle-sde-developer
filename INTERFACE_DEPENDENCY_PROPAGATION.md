# CMake dependency propagation and all-load semantics

## Why this note exists

The CMake library rules in this project are used in two different situations:

1. **A normal mulle-sde/mulle-craft build**, where dependency variables usually
   contain library files or linker arguments; and
2. **An `add_subdirectory` build**, where a dependency can instead resolve to a
   CMake target created by another project in the same build.

The second case needs a little extra handling. An object library does not link
against dependencies, so it does not automatically inherit their usage
requirements (for example, generated include directories, compile definitions,
or build ordering). The local `cmake/Library.cmake` override therefore links
ordinary CMake dependency targets privately to the compile-stage object target.
During `LINK_PHASE`, the final library also propagates selected CMake targets
through its `INTERFACE`, allowing a consumer to write:

```cmake
add_subdirectory(path/to/mulle-core)
target_link_libraries(app PRIVATE mulle-core)
```

without separately linking every constituent dependency.

The important qualification is that a dependency's **link semantics** must be
preserved when it is propagated. A target name alone does not necessarily carry
those semantics.

### Current versus proposed behavior

At the time this note was written, the local override's interface list contains
ordinary dependency libraries, frameworks, and OS-specific libraries only. It
does **not** yet add the all-load/startup categories to that interface list.
The broader change under discussion would do that, which is why the failure
mode below matters: adding those categories as plain target names would be a
semantic regression for dependencies that require forced loading.

The compile-stage usage propagation and the final-link interface propagation
are separate paths. The former can be useful for an `add_subdirectory` build
without implying that the latter is safe for every dependency category.

## The all-load distinction

Some dependencies are deliberately linked with all-load/whole-archive
semantics. This is needed when a static library contains object files whose
symbols are not directly referenced, but whose constructors, registrations, or
side effects are still required.

This project represents those semantics in `cmake/share/AllLoadC.cmake`. The
exact spelling depends on the platform, but examples include:

```text
-Wl,--whole-archive ... -Wl,--no-whole-archive
-force_load <library>
-WHOLEARCHIVE:<library>
```

`cmake/share/AllLoadC.cmake` provides the platform-specific conversion
machinery, and `cmake/share/ExecutableAux.cmake` uses it to turn the all-load
dependency lists into special linker arguments. Consequently, these two forms
are **not necessarily equivalent**:

```cmake
# Ordinary transitive link: may lose all-load behavior
target_link_libraries(wrapper INTERFACE plugin)
```

```cmake
# Explicitly preserve the GNU/Clang whole-archive behavior
target_link_libraries(wrapper INTERFACE
   "$<LINK_LIBRARY:WHOLE_ARCHIVE,plugin>"
)
```

The second form requires a sufficiently recent CMake and still needs a
platform-specific equivalent where `WHOLE_ARCHIVE` is not the appropriate link
feature. It also must not conflict with another link feature or ordinary link
of the same target in the consuming link interface.


## Minimal counterexample

The following disposable experiment was used to make the failure concrete. It
lives outside the repository at:

```text
/tmp/mulle-core-interface-counterexample
```

It contains three targets:

- `plugin`: a static library containing only a registration constructor;
- `wrapper`: a static library exposing the registry count; and
- `app`: an executable that links only `wrapper`.

The plugin source is intentionally not referenced by an ordinary symbol:

```c
extern int registry_count;

#if defined(__GNUC__) || defined(__clang__)
__attribute__((constructor))
#endif
static void register_plugin(void)
{
   ++registry_count;
}
```

The wrapper defines and exposes the registry count:

```c
int registry_count;

int wrapper_registry_count(void)
{
   return registry_count;
}
```

The relevant CMake setup is:

```cmake
add_library(plugin STATIC src/plugin.c)
add_library(wrapper_objects OBJECT src/wrapper.c)

target_link_libraries(wrapper_objects PRIVATE plugin)

add_library(wrapper STATIC $<TARGET_OBJECTS:wrapper_objects>)

if(USE_WHOLE_ARCHIVE)
   target_link_libraries(wrapper INTERFACE
      "$<LINK_LIBRARY:WHOLE_ARCHIVE,plugin>"
   )
else()
   target_link_libraries(wrapper INTERFACE plugin)
endif()

add_executable(app src/main.c)
target_link_libraries(app PRIVATE wrapper)
```

The experiment builds in both modes, but the runtime result differs:

| Propagation | Result |
|-------------|--------|
| `INTERFACE plugin` | `registry_count=0`, program exits with failure |
| `INTERFACE $<LINK_LIBRARY:WHOLE_ARCHIVE,plugin>` | `registry_count=1`, program succeeds |

The ordinary final link resembles:

```text
cc ... -o app libwrapper.a libplugin.a
```

Because no unresolved symbol requires an object from `libplugin.a`, the linker
extracts no object from that archive. The constructor is therefore absent from
the executable and the registry remains empty.

The whole-archive final link resembles:

```text
cc ... -o app libwrapper.a \
   -Wl,--push-state,--whole-archive libplugin.a -Wl,--pop-state
```

The linker is forced to extract the plugin object, so its constructor runs and
increments the registry.

## Safe boundary for the library rules

The `if(TARGET ...)` filtering is useful and should remain: it distinguishes
same-build CMake targets from mulle-craft file paths and prevents absolute
build-machine paths from leaking into a consumer's interface.

However, dependency categories should not all be flattened into one ordinary
interface list:

- **Ordinary dependencies** can generally be propagated as ordinary CMake
  targets.
- **All-load, force-all-load, and startup-all-load dependencies** must retain
  their special linker expressions, or must be deliberately excluded from the
  generic interface propagation path.
- **Compile-stage propagation** and **final-link propagation** solve different
  problems. Linking a dependency privately to an object library can provide
  usage requirements and build ordering; it does not itself force the
  dependency's archive members into a downstream executable.

The concise rule to remember is:

> Propagate ordinary dependency identity; propagate all-load dependencies with
> their linker semantics, not just their target names.

## Scope and follow-up

This note records the reasoning behind the local CMake override. It is not a
replacement for a cross-platform test. The counterexample demonstrates the
GNU/Clang static-archive failure mode; Apple and MSVC use different all-load
spellings and should be validated with their respective toolchains before a
portable implementation is finalized.
