#ifndef <|PROJECT_DOWNCASE_IDENTIFIER|>_include_private_h__
#define <|PROJECT_DOWNCASE_IDENTIFIER|>_include_private_h__


/* DO:    #include this files in sources

   DONT:  #include this files in headers
          #import this file anywhere (except in import-private.h)
 */


/* This is a central include file to keep dependencies out of the library
   C files. It is usually included by .h files only.

   As the name "include-private.h" is standardized across mulle-sde projects,
   .c files are now motile. They can be moved to other projects and don't need
   to be edited.

   If you delete it, it will not be regenerated.
*/

#include "include.h"

/*
 * Include the header file generated by mulle-sde reflect.
 */
#include "_<|PROJECT_NAME|>-include-private.h"

/* You can add some more include statements here */

#endif

