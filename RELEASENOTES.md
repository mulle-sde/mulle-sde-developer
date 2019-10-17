## 0.17.0

* changed to mulle-bashfunctions 2 call convention
* some improvements for vscode
* ask mulle-env for the location of ETC SHARE and VAR directories
* support `MULLE_SOURCETREE_TO_CMAKE_RUN` NO|DISABLE|OFF to disable mulle-sourcetree-to-cmake
* support `MULLE_SOURCETREE_TO_C_RUN` NO|DISABLE|OFF to disable mulle-sourcetree-to-c
* fix `@loader_path` for APPLE in cmake
* STARTUP libraries must reside in separate projects now, which makes everything easier
* support RESOURCES better


### 0.16.3

* fix apple RPATH yet again

### 0.16.2

* apple RPATH needs trailing /

### 0.16.1

* fix travus

## 0.16.0

* improved searchpaths generation for cmake
* remove boring folders from VS project and indexing


### 0.15.3

* adapt sublime-text to new .mulle folders

### 0.15.2

* add optional id for mulle-craft

### 0.15.1

* make some optional binaries optional

## 0.15.0

* optionaltool -> tool migration


### 0.14.6

* support new `MULLE_SDE_PROTECT_PATH` feature

### 0.14.5

* need ranlib on osx

### 0.14.4

* fix installer one more time

### 0.14.3

* fix installer

### 0.14.2

* add some more tools

### 0.14.1

* added some optionaltools for a smother experience
* RPATH install fix for shared libraries and executables
* support for multiphase
* c-sourcetree-update moved to mulle-sourcetree project
* improved tool an optionaltool content
* generally nicer templates for library/framework/executable

### 0.13.7

* search for MulleObjCLoader header instead of of objc-loader.inc

### 0.13.6

* improve `EXECUTABLE_LIBRARY_LIST` use

### 0.13.5

* fix extension placement

### 0.13.4

* test osx too with travis

### 0.13.3

* fix travis

### 0.13.2

* fix travis, improved gitignore generation

### 0.13.1

* try to fix installer

## 0.13.0

* use DISABLE instead of NONE to turn off file generation
* completely new cmake templates with support for three phase mulle-make


### 0.12.2

* c-sourcetree-update can now output to --stdout

### 0.12.1

* add vs-code extensions

## 0.12.0

* use `r_` functions of mulle-bashfunctions 1.8.0


## 0.11.0

* craftinfo moved to mulle-sde
* rename buildinfo to makeinfo and craftinfo to keep the two concepts distinct


## 0.10.0

* Various small improvements


### 0.9.12

* improve comment

### 0.9.11

* Various small improvements

### 0.9.10

* fix mingw cmake systemname to Windows and C define to `_WIN32`
* fixes for mingw

### 0.9.9

* fix quoting problem

### 0.9.8

* respect no-require flag for library and header

### 0.9.7

* travis...

### 0.9.6

* fix travis .travis.yml

### 0.9.5

* improve .travis.yml

### 0.9.4

* Various small improvements

### 0.9.3

* curl can be replaced by wget

### 0.9.2

* improve Documentation

### 0.9.1

* fix aliases to include name again, improve README
* adapt to use of delete instead of clobber

## 0.9.0

* adapt to use of delete instead of clobber


### 0.8.3

* add MotdAux for consistency

### 0.8.2

* forgot a file

### 0.8.1

* fix `INSTALL_LIBRARY_TARGETS`

## 0.8.0

* need a third stage for Library/Executable


## 0.7.0

* dependencies.h is replaced by include.h


### 0.6.28

* correct buildinfo install directory

### 0.6.27

* improve private headers a bit, improve log statement

### 0.6.26

* fix library generation bug, fix buildinfo structure, raise cmake baseline to 3.1, add C11 as default

### 0.6.25

* improved generation of platform specific code + better support for subprojects

### 0.6.24

* fix for `PROJECT_SOURCE_DIR` being .

### 0.6.23

* ensure `.DS_Store` crap is not actually copied and installed

### 0.6.22

* improved logging, fixes for subprojects. small helper tool cmake-graphviz-include added
repackaged on linux

### 0.6.21

* simplify and enhance CMakeLists.txt again

### 0.6.20

* * don't overcomplicate sde, keep complexity in mulle-c

### 0.6.19

* move `ALL_LOAD` up to sde
* use `LC_ALL=C` for sort, improve .gitignore contents

### 0.6.18

* add Dockerfile

### 0.6.17

* improve README.md

### 0.6.16

* simplify README

### 0.6.15

* smallish chage

### 0.6.14

* improve README.md

### 0.6.13

* improved brew formula defintion
* fix formula tap prefix

### 0.6.12

* fix formula tap prefix

### 0.6.11

* fix init permission problem on install

### 0.6.10

* fix debian deps

### 0.6.9

* add travis

### 0.6.8

* improve debian package, fix a bug

### 0.6.7

* add DISABLED to `MULLE_SDE_CMAKE_SOURCES/HEADERS_FILE`

### 0.6.6

* fix package dependencies more

### 0.6.5

* fix homebrew install ruby script

### 0.6.4

* make README.md a demo thing

### 0.6.3

* fix aliases output

### 0.6.2

* rename fix README

### 0.6.1

* rename install to installer, because of name conflict

## 0.6.0

* simplifiy the mulle-sde-developer callbacks as the monitor now crafts...


### 0.5.5

* refix again because life is hard

### 0.5.4

* fix install

### 0.5.3

* fix dox

### 0.5.2

* rename install.sh to install and some more improvements

### 0.5.1

* unified version across all extensions
* add buildinfo oneshot extension, reorganize source patternfiles

### 0.4.9

* adapt to versionfile change in mulle-sde, remove some clutter, fix stuff
* adapt to versionfile change in mulle-sde, remove some clutter, fix stuff

### 0.4.8

* improved extension handling with respect to environment

### 0.4.7

* various improvements
* initial version, mostly based on old mulle-sde-cmake

### 0.4.6

* improved output of cmake files

### 0.4.5

* put cmake files into clobber

### 0.4.4

* use new clobber an all subdirs

### 0.4.3

* no date in generated files for less git problems

### 0.4.2

* general improvements in generated files with `MULLE_TRACE_INCLUDE`

### 0.4.1

* fix for different format

## 0.4.0

* lose redundant CMake prefix off many files
* use an improved scheme do locate and inherit DependenciesAndLibraries.cmake


## 0.3.0

* greatly improved the cmake include code
* move emitted files to .mulle/etc/sde/cmake to keep the project a bit more tidy. Also the files shouldn't be edited anyway


## 0.2.0

* move emitted files to .mulle-sde/data/cmake to keep the project a bit more tidy. Also the files shouldn't be edited anyway


### 0.0.1

* Various small improvements
