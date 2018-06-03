cmake_minimum_required( VERSION 3.0)

project( mulle-sde-cmake NONE)

set( PROJECT_VERSION 0.6.21)


set( EXTENSIONS
src/  #backslash is important
)

install( DIRECTORY ${EXTENSIONS}
DESTINATION "share/mulle-sde/extensions"
USE_SOURCE_PERMISSIONS
)


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
