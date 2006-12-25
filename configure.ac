dnl vim: set sw=4 sts=4 ts=4 noet ft=config foldmethod=marker foldmarker={{{,}}} :
dnl Basic setup
AC_INIT(repodoc, [0.1_beta3], repodoc@gentoo-es.org, repodoc)
AC_PREREQ(2.59)
AC_CONFIG_AUX_DIR(config)
AM_INIT_AUTOMAKE(repodoc, 0.1_beta3)

dnl Basic stuff
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S

dnl {{{ pkg-config
AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
if test "x$PKG_CONFIG" = "xno"; then
	AC_MSG_ERROR([You need to install pkg-config])
fi
dnl }}}

dnl {{{ gtk frontend
AC_MSG_CHECKING([whether to build Gtk frontend])
AC_ARG_ENABLE([gtk],
			  AC_HELP_STRING([--enable-gtk], [Build a Gtk frontend]),
			  [ENABLE_GTK=$enableval
			   AC_MSG_RESULT([$enableval])],
			  [ENABLE_GTK=no
			   AC_MSG_RESULT([no])])
if test "x$ENABLE_GTK" = "xyes" ; then
	dnl {{{ CS compiler
	AC_PATH_PROG(GMCS, gmcs, no)
	CS="C#"
	if test "x$GMCS" = "xno" ; then
		AC_MSG_ERROR([you need a $CS compiler that compiles $CS code])
	fi
	AC_SUBST(GMCS)
	dnl }}}

	dnl {{{ gtk-sharp
	GTKSHARP_REQUIRED_VERSION=2.8
	PKG_CHECK_MODULES(GTKSHARP, gtk-sharp-2.0 >= $GTKSHARP_REQUIRED_VERSION)
	dnl }}}
fi
AC_SUBST([ENABLE_GTK])
AM_CONDITIONAL([ENABLE_GTK], test "x$ENABLE_GTK" = "xyes")
dnl }}}

dnl {{{ libxml2 check
PKG_CHECK_MODULES(LIBXML2DEPS, [libxml-2.0 >= 2.6], [],
				  [AC_MSG_ERROR([libxml2 (http://xmlsoft.org/) is required])])
AC_SUBST(LIBXML2DEPS_CFLAGS)
AC_SUBST(LIBXML2DEPS_LIBS)
dnl }}}

unset BASH
AC_PATH_PROGS(BASH, bash)
if test "x$BASH" = "x" ; then
	AC_MSG_ERROR([bash is required])
fi

dnl {{{ Info about this build
BUILDUSER=`whoami`
AC_SUBST([BUILDUSER])
BUILDHOST=`hostname`
AC_SUBST([BUILDHOST])
BUILDDATE=`date +%Y-%m-%dT%H:%M:%S%z`
AC_SUBST([BUILDDATE])
GIT_DIR="${ac_top_srcdir:-./}/.git"
if test -d "$GIT_DIR"; then
	GITREV=`GIT_DIR=$GIT_DIR git describe 2>/dev/null`
	if test "x$GITVERSION" = "x"; then
		GITREV=`GIT_DIR=$GIT_DIR git rev-parse --short HEAD`
	fi
else
	GITREV=
fi
AC_SUBST([GITREV])
dnl }}}

dnl Makefile generation
AC_OUTPUT(
		  Makefile
		  extras/Makefile
		  frontend/Makefile
		  lib/Makefile
		  modules/Makefile
		  modules/docman/Makefile
		  modules/repodoc/Makefile
		  mono/Makefile
		  mono/Repodoc/Makefile
		  mono/repo_front/Makefile
		  t/Makefile
		  t/t10004/Makefile
		  t/t20000/Makefile
		  t/t20001/Makefile
		  t/t20002/Makefile
		  t/t20003/Makefile
		  t/t20004/Makefile
		  )
