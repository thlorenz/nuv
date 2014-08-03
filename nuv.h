#ifndef __NUV__
#define __NUV__

#include <uv.h>
#include <uv-version.h>

#ifndef UV_VERSION_PATCH
#define UV_VERSION_PATCH 0
#endif

#define UV_VERSION_AT_LEAST(major, minor, patch) \
  (( (major) < UV_VERSION_MAJOR) \
  || ((major) == UV_VERSION_MAJOR && (minor) < UV_VERSION_MINOR) \
  || ((major) == UV_VERSION_MAJOR && \
      (minor) == UV_VERSION_MINOR && (patch) <= UV_VERSION_PATCH))

#if UV_VERSION_AT_LEAST(0, 11, 27)

#define _NUV_IDLE_CB_ARGS uv_idle_t* handle

#elif UV_VERSION_AT_LEAST(0, 10, 28)

#define _NUV_IDLE_CB_ARGS uv_idle_t* handle, int status

#endif /* UV_VERSION_AT_LEAST(0, 11, 0) */

#define NUV_IDLE_CB(name) void name(_NUV_IDLE_CB_ARGS)

#endif /* __NUV__ */
