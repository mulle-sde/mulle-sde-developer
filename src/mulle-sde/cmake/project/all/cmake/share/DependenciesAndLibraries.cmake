### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# Get Libraries first. That way local library definitions override those
# we might inherit from dependencies. The link order should not be affected by
# this.
#
include( _Libraries OPTIONAL)

#
# If we are in an IDE like CLion and the dependencies haven't been made yet
# cmake is unhappy, try to avoid that.
#
if( IS_DIRECTORY "${DEPENDENCY_DIR}")
   include( _Dependencies OPTIONAL)
endif()

# remove some duplicates (can happen, if we alias to an amalgamated library)
list( REMOVE_DUPLICATES INHERITED_INCLUDE_DIRS)
list( REMOVE_DUPLICATES INHERITED_DEFINITIONS)

list( REMOVE_DUPLICATES HEADER_ONLY_LIBRARIES)
list( REMOVE_DUPLICATES DEPENDENCY_LIBRARIES)
list( REMOVE_DUPLICATES DEPENDENCY_FRAMEWORKS)
list( REMOVE_DUPLICATES OS_SPECIFIC_LIBRARIES)
list( REMOVE_DUPLICATES OS_SPECIFIC_FRAMEWORKS)
list( REMOVE_DUPLICATES ALL_LOAD_OS_SPECIFIC_LIBRARIES)
list( REMOVE_DUPLICATES ALL_LOAD_OS_SPECIFIC_FRAMEWORKS)
list( REMOVE_DUPLICATES ALL_LOAD_DEPENDENCY_LIBRARIES)
list( REMOVE_DUPLICATES ALL_LOAD_DEPENDENCY_FRAMEWORKS)
list( REMOVE_DUPLICATES ALL_LOAD_OPTIONAL_DEPENDENCY_LIBRARIES)
list( REMOVE_DUPLICATES ALL_LOAD_OPTIONAL_DEPENDENCY_FRAMEWORKS)
list( REMOVE_DUPLICATES STARTUP_ALL_LOAD_DEPENDENCY_FRAMEWORKS)
list( REMOVE_DUPLICATES STARTUP_ALL_LOAD_DEPENDENCY_FRAMEWORKS)

#
# MEMO: Do not cache anything here. It will affect projects that include
#       this file as part of the inheritance scheme
#
option( INHERIT_DEPENDENCY_INCLUDES "Make headers of dependencies available as local headers" OFF)


if( INHERIT_DEPENDENCY_INCLUDES)
   # message( STATUS "INHERITED_INCLUDE_DIRS=\"${INHERITED_INCLUDE_DIRS}\"" )

   # these generate -I arguments, that add to the user search path
   include_directories( ${INHERITED_INCLUDE_DIRS})
endif()
