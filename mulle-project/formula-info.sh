# -- Formula Info --
# If you don't have this file, there will be no homebrew
# formula operations.
#
PROJECT="mulle-sde-cmake"      # your project/repository name
DESC="🏋🏼 mulle-sde, cmake support"
LANGUAGE="bash"             # c,cpp, objc, bash ...

# LANGUAGE="c"             # c,cpp, objc, bash ...
# NAME="${PROJECT}"        # formula filename without .rb extension

#
# Specify needed homebrew packages by name as you would when saying
# `brew install`.
#
# Use the ${DEPENDENCY_TAP} prefix for non-official dependencies.
# DEPENDENCIES and BUILD_DEPENDENCIES will be evaled later!
# So keep them single quoted.
#
DEPENDENCIES='${TOOLS_TAP}mulle-sde
cmake
'

DEBIAN_DEPENDENCIES="mulle-sde, cmake"


