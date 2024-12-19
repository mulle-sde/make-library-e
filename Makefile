PREFIX ?= /usr/local
DESTDIR ?=
INSTALLOPTIONS ?=
BUILD_DIR ?= build

CFLAGS ?= -O2 -fPIC
LDFLAGS ?= -shared

# Default to static library, use `make SHARED=1` for shared
SHARED ?= 0
ifeq ($(SHARED),1)
LIBRARY = libe.so
LDFLAGS ?= -shared
else
LIBRARY = libe.a
LDFLAGS ?=
endif

SOURCES = src/e.c
OBJECTS = $(SOURCES:src/%.c=$(BUILD_DIR)/%.o)

all: $(BUILD_DIR)/$(LIBRARY)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: src/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -Iinclude -c $< -o $@

ifeq ($(SHARED),1)
$(BUILD_DIR)/$(LIBRARY): $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^
else
$(BUILD_DIR)/$(LIBRARY): $(OBJECTS)
	$(AR) rcs $@ $^
endif

install: $(BUILD_DIR)/$(LIBRARY)
	install $(INSTALLOPTIONS) -d $(DESTDIR)/lib
	install $(INSTALLOPTIONS) -m 755 $(BUILD_DIR)/$(LIBRARY) $(DESTDIR)/lib
	install $(INSTALLOPTIONS) -d $(DESTDIR)/include/e
	install $(INSTALLOPTIONS) -m 644 include/e/e.h $(DESTDIR)/include/e

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all install clean
