# $FreeBSD$

PACKAGE=	fetch
LIB=		fetch
SRCS=	src/fetch.c src/common.c src/ftp.c src/file.c src/http.c src/strnstr.c src/strchrnul.c

INCLUDES_DIR=	${.CURDIR}/includes
OBJS_DIR=	${.CURDIR}/objs
BUILD_DIR=	$(.CURDIR)/build
LIB_DIR=	$(BUILD_DIR)/usr/local/lib
HEADER_DIR=	$(BUILD_DIR)/usr/local/include

CC=	cc
CFLAGS=	-I${INCLUDES_DIR} -fPIC -DINET6 -DWITH_SSL
ARFLAGS= rcs

##
# Public targets
libfetch.a: objs headers
	$(AR) rcs ${LIB_DIR}/${.TARGET} objs/*.o

libfetch.so: objs headers
	$(CC) -shared $(OBJS_DIR)/*.o -lssl -lcrypto -o $(LIB_DIR)/libfetch.so

all: libfetch.a libfetch.so

clean:
	rm -rf \
	$(INCLUDES_DIR)/httperr.h \
	$(INCLUDES_DIR)/ftperr.h \
	$(OBJS_DIR)/*.o \
	$(LIB_DIR)/*.a \
	$(HEADER_DIR)/*.h \

##
# Private targets
headers:
	@cp $(INCLUDES_DIR)/fetch.h $(HEADER_DIR)

objs: clean ftperr.h httperr.h
	@for src in $(SRCS); do \
		obj=$$(basename $$(echo "$${src}" | sed 's/\.c$$/\.o/')); \
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
