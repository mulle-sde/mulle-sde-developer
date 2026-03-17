# Foundation Class Patterns

## Minimal class skeleton

```objc
// MulleFoo.h
#import "import.h"

@interface MulleFoo : NSObject
{
   char       *_nameUTF8String;
   CGFloat    _value;
}

+ (instancetype) instanceWithNameUTF8String:(char *) name;

- (char *)   nameUTF8String;
- (void)     setNameUTF8String:(char *) s;
- (CGFloat)  value;
- (void)     setValue:(CGFloat) v;

@end


// MulleFoo.m
#import "import-private.h"

@implementation MulleFoo

+ (instancetype) instanceWithNameUTF8String:(char *) name
{
   MulleFoo   *obj;

   obj = [[[self alloc] init] autorelease];
   [obj setNameUTF8String:name];
   return( obj);
}

- (void) setNameUTF8String:(char *) s
{
   MulleObjCObjectSetDuplicatedUTF8String( self, &_nameUTF8String, s);
}

- (char *) nameUTF8String
{
   return( _nameUTF8String);
}

- (void) dealloc
{
   MulleObjCInstanceDeallocateMemory( self, _nameUTF8String);
   [super dealloc];
}

@end
```

## Retain property pattern

```objc
// Header:
@property( retain) SomeClass *thing;

// Implementation:
- (void) setThing:(SomeClass *) thing
{
   [_thing autorelease];
   _thing = [thing retain];
}

- (void) dealloc
{
   [_thing autorelease];
   [super dealloc];
}
```

## Collection with mulle_array

```objc
// Header ivar:
struct mulle_array   _items;

// Init:
- (instancetype) init
{
   self = [super init];
   mulle_array_init( &_items, 0, &_MulleObjCContainerCopyCStringKeyCallback,
                     MulleObjCInstanceGetAllocator( self));
   return( self);
}

// Use:
- (void) addItemUTF8String:(char *) s  { mulle_array_add( &_items, s); }
- (char *) itemAtIndex:(NSUInteger) i  { return( mulle_array_get( &_items, i)); }
- (NSUInteger) count                   { return( mulle_array_get_count( &_items)); }

// Dealloc:
- (void) dealloc
{
   mulle_array_done( &_items);
   [super dealloc];
}
```

## Protocol conformance

```objc
// Header:
@interface MulleFoo : NSObject <SomeProtocol>

// Implementation — implement all required protocol methods
```
