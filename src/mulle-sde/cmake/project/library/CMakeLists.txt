cmake_minimum_required( VERSION 3.1)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)
#
# Turn a "Library" into an "Executable"
# * touch src/main.m
# Then set MULLE_PROJECT_TYPE to "Executable".
# * mulle-sde reflect
# * mulle-sde craft
#
set( MULLE_PROJECT_TYPE "Library")

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)
include( Dependencies)

if( "${MULLE_PROJECT_TYPE}" STREQUAL "Executable")

   ### Executable

   include( Dependencies)
   include( Executable)
   include( InstallExecutable)

   # only for Executable
   include( Motd OPTIONAL)


elseif( "${MULLE_PROJECT_TYPE}" STREQUAL "Framework")

   ### Framework

   include( Dependencies)
   include( Framework)

   set_target_properties( "${FRAMEWORK_NAME}" PROPERTIES
     FRAMEWORK_VERSION A
   )

   include( InstallFramework)

elseif( "${MULLE_PROJECT_TYPE}" STREQUAL "Library")

   ### Library

   if( HEADERS_PHASE)
      install( FILES ${INSTALL_PUBLIC_HEADERS}  DESTINATION "include/${PROJECT_NAME}")
      install( FILES ${INSTALL_PRIVATE_HEADERS} DESTINATION "include/${PROJECT_NAME}/private")
      install( FILES ${CMAKE_INCLUDES}          DESTINATION "include/${PROJECT_NAME}/cmake")

      # short cut out
      if( NOT COMPILE_PHASE AND NOT LINK_PHASE)
         return()
      endif()
   endif()

   if( LINK_PHASE)
      include( Dependencies OPTIONAL)
   endif()

   include( Library)
   include( InstallLibrary)

else()

   message( ERROR "Unknown project type \"${MULLE_PROJECT_TYPE}")

endif()

include( FinalOutput OPTIONAL)
