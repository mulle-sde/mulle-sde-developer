cmake_minimum_required( VERSION 3.0)

project( <|PROJECT_NAME|> NONE)

set( PROJECT_VERSION 0.0.0)

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)


set( EXTENSIONS
src/  #backslash is important
)


install( DIRECTORY ${EXTENSIONS}
DESTINATION "share/mulle-sde/extensions"
USE_SOURCE_PERMISSIONS)


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake) # need extension
include( CPack)
