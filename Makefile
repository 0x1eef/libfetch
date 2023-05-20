# $FreeBSD$

PACKAGE=	fetch
LIB=		fetch
SRCS=	fetch.c common.c ftp.c file.c http.c strnstr.c strchrnul.c

INCLUDES_DIR=	${.CURDIR}/includes
OBJS_DIR=	${.CURDIR}/objs
BUILD_DIR=	$(.CURDIR)/build
LIB_DIR=	$(BUILD_DIR)/usr/local/lib

CC=	cc
CFLAGS=	-I${INCLUDES_DIR} -fPIC -DINET6 -DWITH_SSL
ARFLAGS= rcs

##
# Public targets
libfetch.a: objs
	$(AR) rcs ${LIB_DIR}/${.TARGET} objs/*.o

libfetch.so: objs
	$(CC) -shared $(OBJS_DIR)/*.o -o $(LIB_DIR)/libfetch.so

all: libfetch.a libfetch.so

clean:
	rm -rf \
	$(INCLUDES_DIR)/httperr.h \
	$(INCLUDES_DIR)/ftperr.h \
	$(OBJS_DIR)/*.o \
	$(LIB_DIR)/*.a \

##
# Private targets
objs: ftperr.h httperr.h
	@for src in $(SRCS); do \
		obj=$$(echo "$${src}" | sed 's/\.c$$/\.o/'); \
		$(CC) $(CFLAGS) -c "$${src}" -o "${OBJS_DIR}/$${obj}" ; \
	done

ftperr.h: ftp.errors ${.CURDIR}/Makefile
	@echo "static struct fetcherr ftp_errlist[] = {" > ${INCLUDES_DIR}/${.TARGET}
	@cat ${.CURDIR}/ftp.errors \
	  | grep -v ^# \
	  | sort \
	  | while read NUM CAT STRING; do \
	    echo "    { $${NUM}, FETCH_$${CAT}, \"$${STRING}\" },"; \
	  done >> ${INCLUDES_DIR}/${.TARGET}
	@echo "    { -1, FETCH_UNKNOWN, \"Unknown FTP error\" }" >> ${INCLUDES_DIR}/${.TARGET}
	@echo "};" >> ${INCLUDES_DIR}/${.TARGET}

httperr.h: http.errors ${.CURDIR}/Makefile
	@echo "static struct fetcherr http_errlist[] = {" > ${INCLUDES_DIR}/${.TARGET}
	@cat ${.CURDIR}/http.errors \
	  | grep -v ^# \
	  | sort \
	  | while read NUM CAT STRING; do \
	    echo "    { $${NUM}, FETCH_$${CAT}, \"$${STRING}\" },"; \
	  done >> ${INCLUDES_DIR}/${.TARGET}
	@echo "    { -1, FETCH_UNKNOWN, \"Unknown HTTP error\" }" >> ${INCLUDES_DIR}/${.TARGET}
	@echo "};" >> ${INCLUDES_DIR}/${.TARGET}
