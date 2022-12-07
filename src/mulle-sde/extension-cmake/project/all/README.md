# <|PROJECT_NAME|>

This is your mulle-sde <|PROJECT_TYPE|> extension.

`CMakeLists.txt` and `CMakePackage.cmake` are used as an installer for the
extension. The actual extension will be in
`src/<|VENDOR_NAME|>/<|PROJECT_NAME|>`.

See the [mulle-sde Wiki](https://github.com/mulle-sde/mulle-sde/wiki) for
information about how to develop extensions.


## Quick start

Let's assume the purpose of this extension is to add a file `club.txt` to
a project.

This is the minimal setup:

``` bash
(
   cd src/<|VENDOR_NAME|>/<|PROJECT_NAME|>
   mkdir -p project/all
   echo "VfL Bochum 1848" > project/all/club.txt
   echo "0.0.0" > version
   echo "extra" > type
   echo "Adds \"club.txt\" to your projects" > usage
   rm README.md
)
```

> Adding files one time only is a perfect example of an "extra"
> extension or a "oneshot" extension.


## Test without installing the extension

See if your extension is found by **mulle-sde** by running:

``` bash
MULLE_SDE_EXTENSION_BASE_PATH="${PWD}/src" \
   mulle-sde extension list all
```

Get detailed information about your extension with *extension usage*:

``` bash
MULLE_SDE_EXTENSION_BASE_PATH="${PWD}/src" \
   mulle-sde extension usage --info --list '*' <|VENDOR_NAME|>/<|PROJECT_NAME|>
```

Let extension do its thing someplace non-problematic:

``` bash
MULLE_SDE_EXTENSION_BASE_PATH="${PWD}/src" \
MULLE_VIRTUAL_ROOT=  \
   mulle-sde -v -lx init -d /tmp/xxx -e <|VENDOR_NAME|>/<|PROJECT_NAME|> library
exit # leave environment
mulle-sde /tmp/xxx
```

## Install

Run `mulle-make install --prefix /usr/local` or:

``` bash
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B build &&
cmake --build build &&
cmake --install build
```
