cmake_minimum_required( VERSION 3.1)

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

set( PROJECT_FILES
   ${PROJECT_FILES}
   ${SOURCES}
   ${PUBLIC_HEADERS}
   ${PRIVATE_HEADERS}
   ${CMAKE_EDITABLE_FILES}
)

### Executable

include( PreExecutable OPTIONAL)

add_executable( <|PROJECT_NAME|>
   ${PROJECT_FILES}
)

# useful for mulle-c, but can be commented out
set_property( TARGET <|PROJECT_NAME|> PROPERTY CXX_STANDARD 11)

set( EXECUTABLE_LIBRARY_LIST
   ${DEPENDENCY_LIBRARIES}
   ${OPTIONAL_DEPENDENCY_LIBRARIES}
   ${OS_SPECIFIC_LIBRARIES}
)

include( PostExecutable OPTIONAL)


target_link_libraries( <|PROJECT_NAME|>
   ${EXECUTABLE_LIBRARY_LIST}
)


### Install

include( PreInstall OPTIONAL)

install( TARGETS <|PROJECT_NAME|> DESTINATION "bin")

include( PostInstall OPTIONAL)

# only for Executable

include( Motd OPTIONAL)

