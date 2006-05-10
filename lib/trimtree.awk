BEGIN {
	# This is the indent depth used to guess subtrees.
	iDepth=0;

	# Those constructs are a mere performance hack. Given the
	# way awk internally implements arrays it is cheaper to check
	# if a key exists rather than checking if some value is mapped to
	# any key. Without doing lots of numbers this should be of
	# complexity O(m*log n) rather than O(m*n). ('m' being the number
	# of lines read and, 'n' being number of elements in each array ).
	split("p pre note warn impo", preIGNORE);
	for (i in preIGNORE)
		IGNORE[preIGNORE[i]]=1;

	split("p pre note warn impo chapter section ul", preNUMBER);
	for (i in preNUMBER)
		NUMBER[preNUMBER[i]]=1;

	split("body chapter title", preNOCONTEXT);
	for (i in preNOCONTEXT)
		NOCONTEXT[preNOCONTEXT[i]]=1;
}

{
	memb=$0
	lead=$0
	gsub("[^ ]", "", lead);
	cDepth = gsub(" ", "", memb);

	# Check if we are interested in this node. We are not interested
	# if any ANCESTRY of the current subtree exists in IGNORE.
	if (iDepth > 0) {
		if (cDepth <= iDepth)
			iDepth=0;
		else
			next;
	}

	printf("%s", $0);

	# Reset counters when we enter a new context or subcontext.
	if (memb == "chapter") {
		for (i in NUMBER)
			if (i != "chapter")
				COUNT[i] = 0;
	} else if (memb == "section") {
		for (i in NUMBER)
			if (i != "chapter" && i != "section")
				COUNT[i] = 0;
	}

	if (memb in NUMBER)
		printf(" %d", ++COUNT[memb]);

	# This does context output 'calculation'.
	chapctxt="chapter " COUNT["chapter"];
	sectctxt=" , section " COUNT["section"];

	if (memb == "section")
		ctxt=" [ " chapctxt " ]"
	else if (COUNT["chapter"] > 0 && COUNT["section"] > 0)
		ctxt=" [ " chapctxt sectctxt " ]";
	else
		ctxt=""

	if (memb in NOCONTEXT)
		ctxt=""

	printf("%s\n", ctxt);

	# Ignore the subtree we are going to traverse. If current
	# member belongs to IGNORE.
	if (memb in IGNORE)
		iDepth=cDepth;
}
