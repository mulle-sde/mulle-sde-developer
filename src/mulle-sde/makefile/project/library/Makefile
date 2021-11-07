SOURCES=src/<|PROJECT_NAME|>.c
HEADERS=src/<|PROJECT_NAME|>.h

LIB_PREFIX ?= lib
LIB_SUFFIX ?= .a

BUILD_DIR  ?= build
DESTDIR    ?= /usr/local
HEADER_DIR ?= include
LIB_DIR    ?= lib

OBJECTS := $(subst src,$(BUILD_DIR),$(SOURCES))
OBJECTS := $(OBJECTS:.c=.o)


LIBRARY=$(BUILD_DIR)/$(LIB_PREFIX)<|PROJECT_NAME|>$(LIB_SUFFIX)

.PHONY: all clean install

all:	$(LIBRARY)

$(BUILD_DIR)/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIBRARY): $(OBJECTS)
	$(AR) $(ARFLAGS) -o $@ $(OBJECTS)

clean:
	rm -f $(LIBRARY) $(OBJECTS)

install:
	mkdir -p $(DESTDIR)/$(HEADER_DIR)/<|PROJECT_NAME|>
	install $(INSTALLFLAGS) $(HEADERS) $(DESTDIR)/$(HEADER_DIR)/<|PROJECT_NAME|>
	mkdir -p $(DESTDIR)/$(LIB_DIR)
	install $(INSTALLFLAGS) $(LIBRARY) $(DESTDIR)/$(LIB_DIR)
