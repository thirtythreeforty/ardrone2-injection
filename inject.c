#define _GNU_SOURCE
#include <sys/types.h>
#include <dlfcn.h>
#define _FCNTL_H
#include <bits/fcntl.h>
#include <string.h>

extern int errorno;

int (*_open)(const char * pathname, int flags, ...) = 0;

int open(const char * pathname, int flags, mode_t mode)
{
    if(_open == 0)
        _open = (int (*)(const char * pathname, int flags, ...)) dlsym(RTLD_NEXT, "open");

    if(strstr(pathname, "ttyUSB") != NULL) {
        // return an fd to a dummy file
        return _open("/tmp/dummyfile", flags, mode);
    }
    else {
        return _open(pathname, flags, mode);
    }
}
