## About

The goal of this repository is to port libfetch from
[FreeBSD](https://freebsd.org)
to
[OpenBSD](https://openbsd.org).
At the time of writing the library can be built. The `SO_NOSIGPIPE`
socket option does not exist on
[OpenBSD](https://openbsd.org)
and the line that sets that socket option has been removed. Numerous
calls to `__FBSDID` have been removed, and `#define` directives
have been implemented where they were found to be absent but required.

## Build

    git clone https://github.com/0x1eef/libfetch
    cd libfetch
    make ftperr.h httperr.h
    make

## License

[The FreeBSD License](https://www.freebsd.org/copyright/freebsd-license/)






