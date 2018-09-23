cmake_minimum_required( VERSION 3.0)

project( mulle-sde-cmake NONE)

set( PROJECT_VERSION 0.12.2)


set( EXTENSIONS
src/  #backslash is important
)

install( DIRECTORY ${EXTENSIONS}
   DESTINATION "share/mulle-sde/extensions"
   USE_SOURCE_PERMISSIONS
   PATTERN "*._DS_Store" EXCLUDE
)


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
