# $FreeBSD$

PACKAGE=	fetch
LIB=		fetch
SRCS=		${.CURDIR}/src/*.c

INCLUDE_DIR=		${.CURDIR}/include
OBJ_DIR=			${.CURDIR}/obj
BUILD_DIR=			$(.CURDIR)/build
BUILD_LIB_DIR=		$(BUILD_DIR)/usr/local/lib
BUILD_INCLUDE_DIR=	$(BUILD_DIR)/usr/local/include

CC=	cc
CFLAGS=	-I${INCLUDE_DIR} -fPIC -DINET6 -DWITH_SSL
ARFLAGS= rcs

##
# Public targets
libfetch.a: obj headers
	$(AR) rcs ${BUILD_LIB_DIR}/${.TARGET} obj/*.o

libfetch.so: obj headers
	$(CC) -shared $(OBJ_DIR)/*.o -lssl -lcrypto -o $(BUILD_LIB_DIR)/libfetch.so

install:
	@if [ -e "$(BUILD_LIB_DIR)"/*.so ]; then \
		install "$(BUILD_LIB_DIR)"/*.so /usr/local/lib/; \
	fi
	@if [ -e "$(BUILD_LIB_DIR)"/*.a ]; then \
		install "$(BUILD_LIB_DIR)"/*.a /usr/local/lib/; \
	fi
	@if [ -e "$(BUILD_INCLUDE_DIR)"/fetch.h ]; then \
		install "$(BUILD_INCLUDE_DIR)"/fetch.h /usr/local/include/; \
	fi

deinstall:
	@rm -f /usr/local/lib/libfetch.so
	@rm -f /usr/local/lib/libfetch.a
	@rm -f /usr/local/include/fetch.h

all: libfetch.a libfetch.so

libfetch.so: objs
	$(CC) -shared $(OBJS_DIR)/*.o -o $(LIB_DIR)/libfetch.so

clean:
	@rm -rf \
	$(INCLUDE_DIR)/httperr.h \
	$(INCLUDE_DIR)/ftperr.h \
	$(OBJ_DIR)/*.o \
	$(BUILD_LIB_DIR)/*.a \
	$(BUILD_INCLUDE_DIR)/*.h \

all: libfetch.a libfetch.so

##
# Private targets
headers:
	@cp $(INCLUDE_DIR)/fetch.h $(BUILD_INCLUDE_DIR)

obj: clean ftperr.h httperr.h
	@for src in $(SRCS); do \
		obj=$$(basename $$(echo "$${src}" | sed 's/\.c$$/\.o/')); \
		$(CC) $(CFLAGS) -c "$${src}" -o "${OBJ_DIR}/$${obj}" ; \
	done

ftperr.h: ftp.errors ${.CURDIR}/Makefile
	@echo "static struct fetcherr ftp_errlist[] = {" > ${INCLUDE_DIR}/${.TARGET}
	@cat ${.CURDIR}/ftp.errors \
	  | grep -v ^# \
	  | sort \
	  | while read NUM CAT STRING; do \
	    echo "    { $${NUM}, FETCH_$${CAT}, \"$${STRING}\" },"; \
	  done >> ${INCLUDE_DIR}/${.TARGET}
	@echo "    { -1, FETCH_UNKNOWN, \"Unknown FTP error\" }" >> ${INCLUDE_DIR}/${.TARGET}
	@echo "};" >> ${INCLUDE_DIR}/${.TARGET}

httperr.h: http.errors ${.CURDIR}/Makefile
	@echo "static struct fetcherr http_errlist[] = {" > ${INCLUDE_DIR}/${.TARGET}
	@cat ${.CURDIR}/http.errors \
	  | grep -v ^# \
	  | sort \
	  | while read NUM CAT STRING; do \
	    echo "    { $${NUM}, FETCH_$${CAT}, \"$${STRING}\" },"; \
	  done >> ${INCLUDE_DIR}/${.TARGET}
	@echo "    { -1, FETCH_UNKNOWN, \"Unknown HTTP error\" }" >> ${INCLUDE_DIR}/${.TARGET}
	@echo "};" >> ${INCLUDE_DIR}/${.TARGET}
