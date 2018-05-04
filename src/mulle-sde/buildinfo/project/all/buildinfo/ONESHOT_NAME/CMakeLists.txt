cmake_minimum_required( VERSION 3.0)

project( <|ONESHOT_NAME|> NONE)

file( GLOB BUILDINFO_DIRS
   "mulle-make" "mulle-make.*"
)

foreach( DIR ${BUILDINFO_DIRS} )
   install( DIRECTORY "${DIR}" DESTINATION "share/buildinfo/<|ONESHOT_NAME|>")
endforeach()
