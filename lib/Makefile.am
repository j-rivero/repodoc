CLEANFILES = *~
MAINTAINERCLEANFILES = Makefile.in

SUBDIRS = .

OURLIBS = boundary.sh \
		  docpath.sh \
		  libcore.sh \
		  stripxmlcomments.sed \
		  xml.sh \
		  colors.sh \
		  frontend_core.sh \
		  massagelinenumbers.sed \
		  trimtree.awk \
		  xpath.sh

EXTRA_DIST = $(OURLIBS)

ourlibsdir = $(pkgdatadir)/lib
ourlibs_DATA = $(OURLIBS)
