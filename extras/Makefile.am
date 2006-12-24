CLEANFILES = *~
MAINTAINERCLEANFILES = Makefile.in

SUBDIRS = .

extrasdir = $(pkgdatadir)/extras
extras_PROGRAMS = xpatheval check-utf8

xpatheval_SOURCES = xpatheval.c
xpatheval_CFLAGS = @LIBXML2DEPS_CFLAGS@
xpatheval_LDADD = @LIBXML2DEPS_LIBS@

check_utf8_SOURCES = check-utf8.c
