#
# You rarely need to edit this file. To add or remove files in your
# project edit the "src" folders contents and run `mulle-sde reflect`
#
#
# A convenient way to add a new source file is:
#    mulle-sde add src/foo.<|PROJECT_EXTENSION|>
#
cmake_minimum_required( VERSION 3.13)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)

#
# This is not a cmake application bundle (use Application, if it exists)
# but an actual dynamically loaded plugin bundle
#
set( MULLE_PROJECT_TYPE "Bundle")

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/reflect")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

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

include( FinalOutput OPTIONAL)
