if( NOT __<|PROJECT_UPCASE_IDENTIFIER|>_CMAKE_DEPENDENCIES_AND_LIBRARIES_TXT__)
   set( __<|PROJECT_UPCASE_IDENTIFIER|>_CMAKE_DEPENDENCIES_AND_LIBRARIES_TXT__ ON)

   message( STATUS "# Include <|PROJECT_NAME|> CMakeDependenciesAndLibraries.txt")

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

   include( _CMakeDependencies)
   include( _CMakeLibraries)

   # === MULLE-SDE END ===
   #

   # For the benefit of users of your library, provide the find_library
   # statement to find your library and add it to DEPENDENCY_LIBRARIES and
   # DEPENDENCY_NAMES
   #
   if( NOT <|PROJECT_UPCASE_IDENTIFIER|>_LIBRARY)
      find_library( <|PROJECT_UPCASE_IDENTIFIER|>_LIBRARY NAMES <|PROJECT_NAME|>)
      message(STATUS "<|PROJECT_UPCASE_IDENTIFIER|>_LIBRARY is ${<|PROJECT_UPCASE_IDENTIFIER|>_LIBRARY}")
      set( DEPENDENCY_LIBRARIES
         ${<|PROJECT_UPCASE_IDENTIFIER|>_LIBRARY}
         ${DEPENDENCY_LIBRARIES}
         CACHE INTERNAL "need to cache this"
      )
      set( DEPENDENCY_NAMES
         <|PROJECT_NAME|>
         ${DEPENDENCY_NAMES}
         CACHE INTERNAL "need to cache this too"
      )
   endif()

   #
   # For benefit of Windows
   #
   #if( MSVC)
   #   set( <|PROJECT_UPCASE_IDENTIFIER|>_DEFINITIONS $<|PARENT_IDENTIFIER|>_DEFINITIONS})
   #endif()
endif()