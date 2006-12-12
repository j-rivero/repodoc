MCS = gmcs

all: repo_front.exe

Repodoc.dll: Repodoc/Parser.cs
	$(MCS) -t:library -out:$@ $<

repo_front.exe: Repodoc.dll
	$(MCS) -r:Repodoc.dll -out:$@ repo_front.cs

clean:
	$(RM) *.dll *.exe
