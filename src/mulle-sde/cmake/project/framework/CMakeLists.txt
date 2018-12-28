cmake_minimum_required( VERSION 3.1)

project( <|PROJECT_NAME|> <|PROJECT_UPCASE_LANGUAGE|>)

### mulle-sde environment

# add cmake module paths to search path
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake/share")
list( INSERT CMAKE_MODULE_PATH 0 "${PROJECT_SOURCE_DIR}/cmake")

include( Environment)

include( Files)
include( Dependencies)

### Frameworks can't pre-install headers

include( Framework)

set_target_properties( "${FRAMEWORK_NAME}" PROPERTIES
  FRAMEWORK_VERSION A
)

include( InstallFramework)
include( FinalOutput OPTIONAL)
