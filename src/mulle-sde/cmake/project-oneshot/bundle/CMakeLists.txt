#
# You rarely need to edit this file. To add or remove files in your
# project edit the "src" folders contents and run `mulle-sde reflect`
#
#
# A convenient way to add a new source file is:
#    mulle-sde add src/foo.<|PROJECT_EXTENSION|>
#
cmake_minimum_required( VERSION 3.13)

project( <|PROJECT_NAME|> VERSION 0.0.1 LANGUAGES <|PROJECT_UPCASE_LANGUAGE|>)

#
# This is not a cmake application bundle (use Application, if it exists)
# but an actual dynamically loaded plugin bundle
#
set( MULLE_PROJECT_TYPE "Bundle")

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)

#
### Bundle (macOS only)
##
if( LINK_PHASE)
   include( Dependencies)
endif()

include( Bundle)
include( InstallBundle)

#
# Enable this, if you want your project to be compatible with cmake's
# add_subdirectory and find_package. InstallCMakeInclude has the drawback
# of creating a duplicate include/ hierarchy in your project though
# For a bundle, does it make sense ? Maybe InstallCMakeInclude
#
# if( LINK_PHASE)
#    include( InstallCMakeInclude)
#    include( InstallCMakePackage)
# endif()

include( FinalOutput OPTIONAL)
