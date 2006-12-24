CLEANFILES = *.exe *.dll
MAINTAINERCLEANFILES = Makefile.in

SUBDIRS = .

repo_front_SRCS = docs_tree_view.cs \
				  parser.cs \
				  repo_front.cs

EXTRA_DIST = $(repo_front_SRCS)

repofrontdir = $(pkgdatadir)/mono
repofront_SCRIPTS = repo_front.exe

repo_front_ADD = -pkg:gtk-sharp-2.0 -lib:../Repodoc -r:Repodoc.dll

repo_front.exe: $(repo_front_SRCS)
	@GMCS@ -out:$@ $^ $(repo_front_ADD)
