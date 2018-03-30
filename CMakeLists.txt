cmake_minimum_required( VERSION 3.0)

project( mulle-sde-cmake NONE)

set( PROJECT_VERSION 0.4.7)


set( EXTENSIONS
src/  #backslash is important
)

INSTALL( DIRECTORY ${EXTENSIONS}
DESTINATION "share/mulle-sde/extensions")


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
