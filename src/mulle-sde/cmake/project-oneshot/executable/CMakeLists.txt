#
# You rarely need to edit this file. To add or remove files to your
# project edit the "src" folders contents and run `mulle-sde reflect`.
#
# A convenient way to add a new source fils is:
#    mulle-sde add src/foo.<|PROJECT_EXTENSION|>
#
cmake_minimum_required( VERSION 3.13)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)


set( MULLE_PROJECT_TYPE "Executable")

add_definitions( -D<|PROJECT_UPCASE_IDENTIFIER|>_EXTERN_GLOBAL=extern)

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

if( "${MULLE_PROJECT_TYPE}" STREQUAL "Executable")

   ### Executable

   include( Dependencies)
   include( Executable)
   include( InstallExecutable)

   # only for Executable
   include( Motd OPTIONAL)

   # If you only ever want to build this as an executable, you can throw
   # everything else until endif() away

elseif( "${MULLE_PROJECT_TYPE}" STREQUAL "Framework")

   ### Framework

   include( Dependencies)
   include( Framework)

   set_target_properties( "${FRAMEWORK_NAME}" PROPERTIES
     FRAMEWORK_VERSION A
   )

   target_link_options( "${FRAMEWORK_NAME}" PRIVATE
      -undefined dynamic_lookup
   )
   
   include( InstallFramework)

elseif( "${MULLE_PROJECT_TYPE}" STREQUAL "Library")

   ### Library

   if( HEADER_PHASE)
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

   message( ERROR "Unknown project type \"${MULLE_PROJECT_TYPE}\"")

endif()

include( FinalOutput OPTIONAL)


# Advertisement:
#
# Turn an "Executable" into a "Library". This style of development is
# convenient for rapid startup coding where the finished result will be
# transformed into a library. You are also already writing the first
# first test case! There is no code to throw away.
#
# * mulle-sde test init
# * mv src/main.<|PROJECT_EXTENSION|> test/10-first/test.<|PROJECT_EXTENSION|>
# * mulle-sde environment --scope project set PROJECT_TYPE library
# * mulle-sde reflect
# * mulle-sde test
#
# For this to work you need to separate the actual library code into source
# files outside of main.<|PROJECT_EXTENSION|>.
