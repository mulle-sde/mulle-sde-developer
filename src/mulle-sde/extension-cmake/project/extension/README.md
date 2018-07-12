# <|PROJECT_NAME|>

This is your mulle-sde extension template.

See the [mulle-sde Wiki](https://github.com/mulle-sde/mulle-sde/wiki) for
information about how to develop extensions.


## Quick start

Let's assume the purpose of this extension is to add a file `club.txt` to
a project. Adding files one time only is a perfect example of an "extra" 
extension.

This is the minimal setup:

```
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


## Test without installing the extension

See if your extension is found by **mulle-sde** by running:

```
MULLE_SDE_EXTENSION_PATH="${PWD}/src:${MULLE_SDE_EXTENSION_PATH}" \
   mulle-sde extension list all
```

Get detailed information about your extension with *extension usage*:

```
MULLE_SDE_EXTENSION_PATH="${PWD}/src:${MULLE_SDE_EXTENSION_PATH}" \
   mulle-sde extension usage --info --list '*' <|VENDOR_NAME|>/<|PROJECT_NAME|>
```

Let extension do its thing someplace non-problematic:

```
MULLE_SDE_EXTENSION_PATH="${PWD}/src:${MULLE_SDE_EXTENSION_PATH}" \
MULLE_VIRTUAL_ROOT=  \
   mulle-sde -v -lx init -d /tmp/xxx -e <|VENDOR_NAME|>/<|PROJECT_NAME|> library
exit # leave environment
mulle-sde /tmp/xxx
```

## Install

```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make install
```
