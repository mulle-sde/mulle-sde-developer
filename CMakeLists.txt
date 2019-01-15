cmake_minimum_required( VERSION 3.0)

project( mulle-sde-cmake NONE)

set( PROJECT_VERSION 0.14.5)


set( EXTENSIONS
src/  #backslash is important
)

install( DIRECTORY ${EXTENSIONS}
   DESTINATION "share/mulle-sde/extensions"
   USE_SOURCE_PERMISSIONS
   PATTERN "*._DS_Store" EXCLUDE
   PATTERN "*.ignore" EXCLUDE
)


set( SCRIPTS
   mulle-cmake-graphviz-include
   mulle-create-build-motd
)


INSTALL( FILES ${SCRIPTS}
PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
            GROUP_EXECUTE GROUP_READ
            WORLD_EXECUTE WORLD_READ
DESTINATION "bin")


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
