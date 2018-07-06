#include "include.h"

#include <stdint.h>

/*
 *  (c) <|YEAR|> <|USER|> <|ORGANIZATION|>
 *
 *  version:  major, minor, patch
 */
#define <|PROJECT_UPCASE_IDENTIFIER|>_VERSION  ((0 << 20) | (7 << 8) | 56)


static inline unsigned int   <|PROJECT_IDENTIFIER|>_get_version_major( void)
{
   return( <|PROJECT_UPCASE_IDENTIFIER|>_VERSION >> 20);
}


static inline unsigned int   <|PROJECT_IDENTIFIER|>_get_version_minor( void)
{
   return( (<|PROJECT_UPCASE_IDENTIFIER|>_VERSION >> 8) & 0xFFF);
}


static inline unsigned int   <|PROJECT_IDENTIFIER|>_get_version_patch( void)
{
   return( <|PROJECT_UPCASE_IDENTIFIER|>_VERSION & 0xFF);
}


extern uint32_t   <|PROJECT_IDENTIFIER|>_get_version( void);

/*
   Add other library headers here like so, for exposure to library
   consumers.

   # include "foo.h"
*/
