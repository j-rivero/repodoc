all: repo_front.exe

Repodoc.dll: Repodoc/Parser.cs
	mcs -t:library -out:$@ $<

repo_front.exe: Repodoc.dll
	mcs -r:Repodoc.dll -out:$@ repo_front.cs

clean:
	$(RM) *.dll *.exe
