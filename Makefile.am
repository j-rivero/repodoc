EXTRA_DIST = repodoc docman \
			 ChangeLog AUTHORS

MAINTAINERCLEANFILES = aclocal.m4 configure Makefile.in config/config.guess \
					   config/ltmain.sh config/config.sub

DISTCHECK_CONFIGURE_FLAGS = --enable-gtk

SUBDIRS = extras mono lib modules frontend t .

mainscriptsdir = $(pkgdatadir)
mainscripts_SCRIPTS = repodoc docman

install-data-local: install-symlinks

uninstall-local: remove-symlinks

install-symlinks:
	$(LN_S) $(DESTDIR)$(pkgdatadir)/repodoc $(DESTDIR)$(bindir)/repodoc
	$(LN_S) $(DESTDIR)$(pkgdatadir)/docman $(DESTDIR)$(bindir)/docman

remove-symlinks:
	$(RM) $(DESTDIR)$(bindir)/repodoc
	$(RM) $(DESTDIR)$(bindir)/docman
