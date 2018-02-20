
#
# Output message of a day to locate output.
# But if create-build-motd doesn't exist, it's no biggy
#
add_custom_target( __motd__ ALL
   COMMAND [ ! -x "${MULLE_VIRTUAL_ROOT}/.mulle-sde/bin/create-build-motd" ] ||
           "${MULLE_VIRTUAL_ROOT}/.mulle-sde/bin/create-build-motd"
              "executable"
              "${CMAKE_BINARY_DIR}"
              "${PROJECT_NAME}"
   COMMENT "Creating a motd file for mulle-craft"
)

add_dependencies( __motd__ ${PROJECT_NAME})
