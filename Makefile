TOPDIR?= $(shell pwd)

include uv.mk

INCLUDES=-I$(TOPDIR)
LDFLAGS=
CFLAGS=-g -O2 -Wall
LIBS=

INCLUDES +=$(uv_INCLUDES)
CFLAGS+=$(uv_CFLAGS)
LDFLAGS += $(uv_LDFLAGS)
LIBS += $(uv_LIBS)

examples/%: $(uv_LIBA)
	$(CC) $(CFLAGS) $(LDFLAGS) $(INCLUDES) $(LIBS) $(@:%=%.c) $^ -o $@

clean:
		find . -name "*.gc*" -exec rm {} \;
		rm -rf `find . -name "*.dSYM" -print`
		rm -f examples/idle-basic

.PHONY: clean 
