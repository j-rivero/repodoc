MCS = gmcs

all: repo_front.exe

Repodoc_dll_SOURCES = $(wildcard Repodoc/*.cs)

Repodoc.dll: $(Repodoc_dll_SOURCES)
	$(MCS) -t:library -out:$@ $^

repo_front_SOURCES = $(wildcard repo_front/*.cs)

repo_front.exe: Repodoc.dll $(repo_front_SOURCES)
	$(MCS) -pkg:gtk-sharp-2.0 -r:Repodoc.dll -out:$@ $(repo_front_SOURCES)

clean:
	$(RM) *.dll *.exe
