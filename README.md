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
Similarly, functions that aren't available on OpenBSD (ie `strnstr`,
`strchrnul`) but are used by libfetch have also been implemented.

## Build

    git clone https://github.com/0x1eef/libfetch
    cd libfetch
    make ftperr.h httperr.h
    make

## Sources

* [GitHub (source code)](https://github.com/0x1eef/libfetch)
* [GitLab (source code)](https://gitlab.com/0x1eef/libfetch)

## License

[The FreeBSD License](https://www.freebsd.org/copyright/freebsd-license/)






