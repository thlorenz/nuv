# allow overriding libuv dir that's used to quickly switch versions
# during development
uv_TOPDIR=$(TOPDIR)/libuv$($UV_VERSION)
uv_LIBA=$(uv_TOPDIR)/out/Debug/libuv.a
uv_VERSION_HEADER=$(uv_TOPDIR)/include/uv-version.h

$(uv_LIBA): $(uv_TOPDIR)
	cd $(uv_TOPDIR) &&                                                                                              \
	test -d ./build/gyp || (mkdir -p ./build && git clone https://git.chromium.org/external/gyp.git ./build/gyp) && \
	./gyp_uv.py -f make &&                                                                                          \
	cd $(uv_TOPDIR)/out && $(MAKE) -j 8 
	# uv v0.10.x doesn't include patch version in a header file, so we need to fix that
	test -f $(uv_VERSION_HEADER) || cat libuv/src/version.c | grep '#define UV_VERSION_PATCH' >> $(uv_VERSION_HEADER)

# used to switch between versions quickly simply linking the libuv dir
# this is needed to make tools like vim work, i.e. .clang_complete includes libuv
ln_%:
	rm -rf $(TOPDIR)/libuv
	ln -s  $(TOPDIR)/libuv$(@:ln_%=%) $(TOPDIR)/libuv

uv_v10:
	rm -f $(uv_LIBA)
	cd $(uv_TOPDIR) && git reset HEAD --hard --quiet  && git checkout v0.10.28 --force

uv_master:
	rm -f $(uv_LIBA)
	cd $(uv_TOPDIR) && git reset HEAD --hard --quiet  && git checkout master --force

$(uv_TOPDIR):
	git clone https://github.com/joyent/libuv.git

uv_INCLUDES = -I$(uv_TOPDIR)/include -I$(uv_TOPDIR)/src

uv_CFLAGS = 
uv_LDFLAGS=

uname_S=$(shell uname -s)
ifeq (Darwin, $(uname_S))
uv_CFLAGS+=-D_DARWIN_USE_64_BIT_INODE=1
uv_CFLAGS+=-framework CoreServices
uv_LDFLAGS+=-framework Foundation   \
						-framework CoreFoundation \
						-framework ApplicationServices
endif

ifeq (Linux, $(uname_S))
	uv_LDFLAGS += -lrt -ldl -lm -pthread
endif

