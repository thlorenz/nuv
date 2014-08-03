uv_TOPDIR=$(TOPDIR)/libuv
uv_LIBA=$(uv_TOPDIR)/out/Debug/libuv.a

uv_INCLUDES = -I$(uv_TOPDIR)/include -I$(uv_TOPDIR)/src

uv_CFLAGS = 
uv_LDFLAGS=
uv_LIBS=

uname_S=$(shell uname -s)
ifeq (Darwin, $(uname_S))
uv_CFLAGS+=-D_DARWIN_USE_64_BIT_INODE=1
uv_CFLAGS+=-framework CoreServices
uv_LDFLAGS+=-framework Foundation   \
						-framework CoreFoundation \
						-framework ApplicationServices
endif

ifeq (Linux, $(uname_S))
	uv_LIBS += -lrt -ldl -lm -pthread
endif

$(uv_LIBA): $(uv_TOPDIR)
	cd $(uv_TOPDIR) &&                                                                                              \
	test -d ./build/gyp || (mkdir -p ./build && git clone https://git.chromium.org/external/gyp.git ./build/gyp) && \
	./gyp_uv.py -f make &&                                                                                          \
	cd $(uv_TOPDIR)/out && $(MAKE) -j 8

$(uv_TOPDIR):
	git clone https://github.com/joyent/libuv.git

