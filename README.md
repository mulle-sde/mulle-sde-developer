# 🏋🏼 mulle-sde, cmake support

This is a [mulle-sde](//github.com/mulle-sde/mulle-sde) *buildtool extension*
for the [cmake](//cmake.org) build-system.
It is generally installed as a dependency to a *meta extension* such as
[mulle-sde-cmake-c](//github.com/mulle-sde/mulle-sde-cmake-c), but it is usable
on its own.

## Install

OS          | Command
------------|------------------------------------
macos       | `brew install mulle-kybernetik/software/mulle-sde-cmake`
other       | Install prerequisite [mulle-sde](//github.com/mulle-sde/mulle-sde) first. Then `./install.sh`



Executable                         | Description
-----------------------------------|--------------------------------
`mulle-sde-cmake-source-update`    | Generate cmake files from filesystem
`mulle-sde-cmake-sourcetree-update`| Generate cmake files from mulle-sourcetree


## mulle-sde integration

**mulle-sde** affects an *update* by calling the `source` and `sourcetree`
callbacks and executing the required tasks. These callbacks and tasks are when
choosing the *buildtool* extension `mulle-sde:cmake`.

![](dox/mulle-sde-update.png)

The callbacks trigger the "cmake-source-update" and "cmake-sourcetree-update"
tasks. They in turn will execute `mulle-sde-cmake-source-update` and
`mulle-sde-cmake-sourcetree-update` respectively.

**mulle-sde-cmake-source-update** will create the files `_CMakeHeaders.cmake`
and `_CMakeSources.cmake` from the examination of the `src` folder and its
subfolders according to the installed *patternfiles* and place them in
`.mulle-sde/etc/cmake`.

**mulle-sde-cmake-sourcetree-update** will create `_CMakeDependencies.cmake`
and `_CMakeLibraries.cmake` from the contents of the
[mulle-sourcetree](/mulle-sde/mulle-sourcetree) and will also place them in
`.mulle-sde/etc/cmake`.


![](dox/mulle-sde-update-fs.png)


## Customization

`mulle-sde-cmake-source-update` will emit cmake definitions according to the
*patternfile* category. As an example:

Your *patternfile* is called `00-source--experimental`. All files matching
this *patternfile* will be emitted as:

```
set( EXPERIMENTAL
...
)
```
