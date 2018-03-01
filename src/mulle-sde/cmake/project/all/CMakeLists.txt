cmake_minimum_required( VERSION 3.0)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)


### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/.mulle-sde/share/cmake")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/.mulle-sde/etc/cmake")
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


### Library
#
#include( PreLibrary OPTIONAL)
#
#include( PostLibrary OPTIONAL)

### Executable
#
#include( PreExecutable OPTIONAL)
#
#include( PostExecutable OPTIONAL)
#
#include( Motd OPTIONAL)


### Install
#
#include( PreInstall OPTIONAL)
#
#include( PostInstall OPTIONAL)


