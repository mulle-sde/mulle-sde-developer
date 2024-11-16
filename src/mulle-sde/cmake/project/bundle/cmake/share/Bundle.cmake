### If you want to edit this, copy it from cmake/share to cmake. It will be
### picked up in preference over the one in cmake/share. And it will not get
### clobbered with the next upgrade.

# This in theory can be included multiple times

if( MULLE_TRACE_INCLUDE)
   message( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# BUNDLES do not support three-phase build
#
if( NOT BUNDLE_NAME)
   set( BUNDLE_NAME "${PROJECT_NAME}")
endif()
if( NOT BUNDLE_VERSION)
   set( BUNDLE_VERSION "A")
endif()

include( StringCase)

if( NOT BUNDLE_IDENTIFIER)
   snakeCaseString( "${BUNDLE_NAME}" BUNDLE_IDENTIFIER)
endif()
if( NOT BUNDLE_UPCASE_IDENTIFIER)
   string( TOUPPER "${BUNDLE_IDENTIFIER}" BUNDLE_UPCASE_IDENTIFIER)
endif()
if( NOT BUNDLE_DOWNCASE_IDENTIFIER)
   string( TOLOWER "${BUNDLE_IDENTIFIER}" BUNDLE_DOWNCASE_IDENTIFIER)
endif()


# if( NOT BUNDLE_DOWNCASE_IDENTIFIER)
#    string( TOLOWER "${BUNDLE_IDENTIFIER}" BUNDLE_DOWNCASE_IDENTIFIER)
# endif()

if( NOT BUNDLE_FILES)
   set( BUNDLE_FILES "${PROJECT_FILES}")
   set( __BUNDLE_FILES_UNSET ON)
endif()


include( PreBundle OPTIONAL)

if( NOT BUNDLE_FILES)
   message( SEND_ERROR "There are no sources to compile for framework ${BUNDLE_NAME}. Did mulle-sde reflect run yet ?")
endif()

add_library( "${BUNDLE_NAME}" SHARED
   ${BUNDLE_FILES}
)

set_target_properties( "${BUNDLE_NAME}"
   PROPERTIES
      CXX_STANDARD 11
#      DEFINE_SYMBOL "${BUNDLE_UPCASE_IDENTIFIER}_SHARED_BUILD"
)
target_compile_definitions( "${BUNDLE_NAME}" PRIVATE "${BUNDLE_UPCASE_IDENTIFIER}_BUILD")

include( BundleAux OPTIONAL)

if( NOT BUNDLE_LIBRARY_LIST)
  set( BUNDLE_LIBRARY_LIST
    ${DEPENDENCY_LIBRARIES}
    ${DEPENDENCY_FRAMEWORKS}
    ${OPTIONAL_DEPENDENCY_LIBRARIES}
    ${OPTIONAL_DEPENDENCY_FRAMEWORKS}
    ${OS_SPECIFIC_LIBRARIES}
    ${OS_SPECIFIC_FRAMEWORKS}
  )
endif()

set( SHARED_LIBRARY_LIST ${BUNDLE_LIBRARY_LIST})

include( PostSharedLibrary OPTIONAL) # additional hook

target_link_libraries( "${BUNDLE_NAME}"
   ${SHARED_LIBRARY_LIST} # use SHARED_LIBRARY_LIST because of PostSharedLibrary
)


set_target_properties( "${BUNDLE_NAME}" PROPERTIES
  BUNDLE TRUE
  BUNDLE_VERSION "${BUNDLE_VERSION}"
  # headers must be part of ${BUNDLE_NAME} target else it don't work
  PUBLIC_HEADER "${INSTALL_PUBLIC_HEADERS}"
  PRIVATE_HEADER "${INSTALL_PRIVATE_HEADERS}"
  RESOURCE "${INSTALL_RESOURCES}"
  # XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
)

# message( STATUS "INSTALL_PUBLIC_HEADERS=${INSTALL_PUBLIC_HEADERS}")
# message( STATUS "INSTALL_PRIVATE_HEADERS=${INSTALL_PRIVATE_HEADERS}")
# message( STATUS "INSTALL_RESOURCES=${INSTALL_RESOURCES}")
message( STATUS "SHARED_LIBRARY_LIST=${SHARED_LIBRARY_LIST}")

set( INSTALL_BUNDLE_TARGETS
   "${BUNDLE_NAME}"
   ${INSTALL_BUNDLE_TARGETS}
)

include( PostBundle OPTIONAL)


# clean BUNDLE_FILES for the next run, if set by this script
if( __BUNDLE_FILES_UNSET )
   unset( BUNDLE_FILES)
   unset( __BUNDLE_FILES_UNSET)
endif()

