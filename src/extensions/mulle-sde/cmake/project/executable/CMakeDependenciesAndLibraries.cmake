#
# Put your find_library() statements here to import other libraries
#
# Add OS specific dependencies to OS_SPECIFIC_LIBRARIES
# Add all other dependencies (rest) to C_DEPENDENCIES_LIBRARIES

#
# === MULLE-SDE START ===

# `mulle-sde update` will generate these files

include( .mulle-sde/etc/cmake/_CMakeDependencies.cmake)
include( .mulle-sde/etc/cmake/_CMakeLibraries.cmake)

# === MULLE-SDE END ===
#
#

