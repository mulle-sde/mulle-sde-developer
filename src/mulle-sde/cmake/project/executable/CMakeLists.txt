cmake_minimum_required( VERSION 3.0)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)


### Files

include( PreFiles OPTIONAL)

#
# Include all .cmake files in ./cmake
#
file( GLOB LOCAL_CMAKE_INCLUDES
   "cmake/[A-Za-z0-9]*.cmake"
)

foreach( FILE ${LOCAL_CMAKE_INCLUDES} )
   include( "${FILE}")
endforeach()


include( PostFiles OPTIONAL)


### Executable

include( PreExecutable OPTIONAL)

add_executable( <|PROJECT_NAME|>
   ${SOURCES}
   ${PUBLIC_HEADERS}
   ${PRIVATE_HEADERS}
   ${CMAKE_EDITABLE_FILES}
)


target_link_libraries( <|PROJECT_NAME|>
   ${DEPENDENCY_LIBRARIES}
   ${OS_SPECIFIC_LIBRARIES}
)

include( PostExecutable OPTIONAL)

### Install

include( PreInstall OPTIONAL)

install( TARGETS <|PROJECT_NAME|> DESTINATION "bin")

include( PostInstall OPTIONAL)

# only for Executable

include( Motd OPTIONAL)

