cmake_minimum_required( VERSION 3.13...99.99)

project( mulle-sde-cmake VERSION 0.29.1 LANGUAGES NONE)

# important for mulle-project-version to have this separate
set( PROJECT_VERSION 0.29.1)


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


set( BASH_COMPLETION
   bash-completion.sh
)


INSTALL( FILES ${BASH_COMPLETION}
PERMISSIONS OWNER_WRITE OWNER_READ
            GROUP_READ
            WORLD_READ
DESTINATION "share/bash-completion/completions"
RENAME "mulle-sde-developer")


######
#
# must be after CPACK_PACKAGE_VERSION
include( CMakePackage.cmake)
include( CPack)
