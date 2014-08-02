include uv.mk

INCLUDES=
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
		rm -f `find libuv -name *.o` 
		rm -f `find libuv -name libuv.a` 
		rm -f examples/idle-basic
		$(MAKE) -C $(uv_TOPDIR)/out $@

.PHONY: clean 
