CLEANFILES = *~ *.dll *.exe
MAINTAINERCLEANFILES = Makefile.in

SUBDIRS = .

Repodoc_dll_SRCS = Document.cs Parser.cs

EXTRA_DIST = $(Repodoc_dll_SRCS)

repodocdlldir = $(pkgdatadir)/mono/Repodoc/
repodocdll_DATA = Repodoc.dll

Repodoc.dll: $(Repodoc_dll_SRCS)
	@GMCS@ -t:library -out:$@ $^
