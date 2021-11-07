SOURCES=src/main.c

EXE_PREFIX  =
EXE_SUFFIX ?=

BUILD_DIR ?= build
DESTDIR   ?= /usr/local
BIN_DIR   ?= bin

OBJECTS := $(subst src,$(BUILD_DIR),$(SOURCES))
OBJECTS := $(OBJECTS:.c=.o)


EXECUTABLE=$(BUILD_DIR)/$(EXE_PREFIX)<|PROJECT_NAME|>$(EXE_SUFFIX)

.PHONY: all clean install

all:	$(EXECUTABLE)

$(BUILD_DIR)/%.o: src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $< $(LIBS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)


install:
	mkdir -p $(DESTDIR)/$(BIN_DIR)
	install $(INSTALLFLAGS) $(EXECUTABLE) $(DESTDIR)/$(BIN_DIR)
