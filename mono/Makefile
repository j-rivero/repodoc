MCS = gmcs

all: repo_front.exe

Repodoc_dll_SOURCES = Repodoc/Parser.cs Repodoc/Document.cs

Repodoc.dll: $(Repodoc_dll_SOURCES)
	$(MCS) -t:library -out:$@ $^

repo_front.exe: Repodoc.dll
	$(MCS) -r:Repodoc.dll -out:$@ repo_front.cs

clean:
	$(RM) *.dll *.exe
