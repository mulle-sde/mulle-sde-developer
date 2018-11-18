### Files
if( NOT __FILES__CMAKE__)
   set( __FILES___CMAKE__ ON)

include( PreFiles OPTIONAL)

include( "cmake/Headers.cmake" OPTIONAL)
include( "cmake/Sources.cmake" OPTIONAL)
include( "cmake/DependenciesAndLibraries.cmake" OPTIONAL)

include_directories( ${INCLUDE_DIRS})

include( PostFiles OPTIONAL)

set( PROJECT_FILES
   ${PROJECT_FILES}
   ${SOURCES}
   ${PUBLIC_HEADERS}
   ${PRIVATE_HEADERS}
   ${CMAKE_EDITABLE_FILES}
)

set( PROJECT_INSTALLABLE_HEADERS
   ${PUBLIC_HEADERS}
   ${PRIVATE_HEADERS}
)

endif()

