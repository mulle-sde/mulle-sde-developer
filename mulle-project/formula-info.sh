# -- Formula Info --
# If you don't have this file, there will be no homebrew
# formula operations.
#
PROJECT="mulle-sde-developer"      # your project/repository name
DESC="🎓 mulle-sde installer + various extensions for mulle-sde"
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
DEPENDENCIES='${MULLE_SDE_TAP}mulle-sde
cmake
git
'

DEBIAN_DEPENDENCIES='mulle-sde, cmake( >= 3.0), git'

