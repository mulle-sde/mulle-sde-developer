#ifndef <|PROJECT_DOWNCASE_IDENTIFIER|>_h__
#define <|PROJECT_DOWNCASE_IDENTIFIER|>_h__

#include <stdint.h>

/*
 *  (c) <|YEAR|> <|USER|> <|ORGANIZATION|>
 *
 *  version:  major, minor, patch
 */
#define <|PROJECT_UPCASE_IDENTIFIER|>_VERSION  ((0UL << 20) | (7 << 8) | 56)


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


// mulle-c11 feature: <|PROJECT_UPCASE_IDENTIFIER|>_GLOBAL
uint32_t   <|PROJECT_IDENTIFIER|>_get_version( void);

#endif

