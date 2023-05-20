## About

The goal of this repository is to port libfetch from
[FreeBSD](https://freebsd.org)
to
[OpenBSD](https://openbsd.org).
At the time of writing the library can be built as a static library,
and as a shared library.

The `SO_NOSIGPIPE` socket option does not exist on
[OpenBSD](https://openbsd.org)
and the line that sets that socket option has been removed. Numerous
calls to `__FBSDID` have been removed, and `#define` directives
have been implemented where they were found to be absent but required.
Similarly, functions that aren't available on OpenBSD (ie `strnstr`,
`strchrnul`) but are used by libfetch have also been implemented.

## Build

    # Clone
    git clone https://github.com/0x1eef/libfetch
    cd libfetch
    
    # Build static library (./build/usr/local/lib/libfetch.a)
    make libfetch.a
    
    # Build shared library (./build/usr/local/lib/libfetch.so)
    make libfetch.so
    
    # Build both static and shared libraries
    make all

## Sources

* [GitHub (source code)](https://github.com/0x1eef/libfetch)
* [GitLab (source code)](https://gitlab.com/0x1eef/libfetch)

## License

[The FreeBSD License](https://www.freebsd.org/copyright/freebsd-license/)






