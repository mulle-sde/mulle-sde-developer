if( NOT __<|PROJECT_UPCASE_IDENTIFIER|>_DEPENDENCIES_AND_LIBRARIES_CMAKE__)
   set( __<|PROJECT_UPCASE_IDENTIFIER|>_DEPENDENCIES_AND_LIBRARIES_CMAKE__ ON)

   message( STATUS "# Include <|PROJECT_NAME|> DependenciesAndLibraries.cmake")

   #
   # Put your find_library() statements here to import other libraries
   #
   # Add OS specific dependencies to OS_SPECIFIC_LIBRARIES
   # Add all other dependencies (rest) to DEPENDENCIES_LIBRARIES


   #
   # The following includes include definitions generated
   # during `mulle-sde update`. Don't edit those files. They are
   # overwritten frequently.
   #
   # === MULLE-SDE START ===

   # `mulle-sde update` will generate these files

   include( _Dependencies)
   include( _Libraries)

   # === MULLE-SDE END ===
   #

   #
   # For benefit of Windows
   #
   #if( MSVC)
   #   set( <|PROJECT_UPCASE_IDENTIFIER|>_DEFINITIONS $<|PARENT_IDENTIFIER|>_DEFINITIONS})
   #endif()
endif()