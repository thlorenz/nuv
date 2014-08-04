#ifndef __NUV__
#define __NUV__

#include <uv.h>

#ifndef UV_VERSION_PATCH
#include <uv-version.h>
#endif

#define UV_VERSION_AT_LEAST(major, minor, patch)                 \
  (( (major) < UV_VERSION_MAJOR)                                 \
  || ((major) == UV_VERSION_MAJOR && (minor) < UV_VERSION_MINOR) \
  || ((major) == UV_VERSION_MAJOR &&                             \
      (minor) == UV_VERSION_MINOR && (patch) <= UV_VERSION_PATCH))

#if defined(__GNUC__) && !defined(DEBUG)
  #define NUV_INLINE inline __attribute__((always_inline))
#elif defined(_MSC_VER) && !defined(DEBUG)
  #define NUV_INLINE __forceinline
#else
  #define NUV_INLINE inline
#endif

#if UV_VERSION_AT_LEAST(0, 11, 27)

NUV_INLINE const char* NUV_err_name(int code) {
  return uv_err_name(code);
}

NUV_INLINE const char* NUV_strerror(int code) {
  return uv_strerror(code);
}

int NUV_fs_read(uv_loop_t* loop, uv_fs_t* req, uv_file file,
    const uv_buf_t bufs[], unsigned int nbufs, int64_t offset, uv_fs_cb cb) {
  return uv_fs_read(loop, req, file, bufs, nbufs, offset, cb);
}

#define _NUV_IDLE_CB_ARGS uv_idle_t* handle
#define NUV_IDLE_STATUS 0

#elif UV_VERSION_AT_LEAST(0, 10, 28)

NUV_INLINE const char* NUV_err_name(int code) {
  uv_err_t err = { .code = code };
  return uv_err_name(err);
}

NUV_INLINE const char* NUV_strerror(int code) {
  uv_err_t err = { .code = code };
  return uv_strerror(err);
}

int NUV_fs_read(uv_loop_t* loop, uv_fs_t* req, uv_file file,
    const uv_buf_t bufs[], unsigned int nbufs, int64_t offset, uv_fs_cb cb) {
  /* HACK: ignoring nbufs here since older libuv had no notior of such a thing */
  return uv_fs_read(loop, req, file, (void*) bufs, bufs->len, offset, cb);
}

#define _NUV_IDLE_CB_ARGS uv_idle_t* handle, int status
#define NUV_IDLE_STATUS status

#endif /* UV_VERSION_AT_LEAST(0, 11, 0) */

#define NUV_IDLE_CB(name) void name(_NUV_IDLE_CB_ARGS)

#endif /* __NUV__ */
