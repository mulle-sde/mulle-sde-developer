/*
 * template: demo/library/PROJECT_SOURCE_DIR/PROJECT_NAME.PROJECT_EXTENSION
 * vendor/extension: mulle-sde/makefile
 */
#<|INCLUDE_COMMAND|> "<|PROJECT_NAME|>.h"


int   __<|PROJECT_UPCASE_IDENTIFIER|>_ranlib__;


uint32_t   <|PROJECT_IDENTIFIER|>_get_version( void)
{
   return( <|PROJECT_UPCASE_IDENTIFIER|>_VERSION);
}

