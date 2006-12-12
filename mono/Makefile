all: repo_front.exe

RepodocParser.dll: RepodocParser.cs
	mcs -t:library $<

repo_front.exe: RepodocParser.dll
	mcs -r:RepodocParser.dll repo_front.cs

clean:
	$(RM) *.dll *.exe
