## About

This repository contains a fork of the libfetch library from
the [FreeBSD project](https://freebsd.org). The goal of
the fork is to add support for more platforms, in particular
OpenBSD support.

## Build

    # Clone
    git clone https://github.com/0x1eef/libfetch
    cd libfetch

    # Build static library
    make libfetch.a

    # Build shared library
    make libfetch.so

    # Install into /usr/local/
    make install

    # Deinstall libfetch from /usr/local/
    make deinstall

## Changelog

* Improve build environment (Makefile, etc).
* Add C functions absent on OpenBSD: `strnstr`, `strchrnul`.
* Add `#define` directives absent on OpenBSD (see `include/fetch.h`).
* Remove socket option absent on OpenBSD (`SO_NOSIGPIPE`).
* Remove references to `__FBSDID`.

## Sources

* [GitHub](https://github.com/0x1eef/libfetch)
* [GitLab](https://gitlab.com/0x1eef/libfetch)
* [git.hardenedbsd.org](https://git.hardenedbsd.org/0x1eef/libfetch/)

## License

[The FreeBSD License](https://www.freebsd.org/copyright/freebsd-license/)
