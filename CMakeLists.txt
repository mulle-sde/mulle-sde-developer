cmake_minimum_required( VERSION 3.13...99.99)

project( mulle-sde-cmake VERSION 0.29.2 LANGUAGES NONE)

# important for mulle-project-version to have this separate
set( PROJECT_VERSION 0.29.2)


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
