#
# Convenient XPath lib/
#

doxpath() {
	${EXTRA_DIR}/xpatheval $* 2>/dev/null
}

# Specify a GuideXML thingie and it will give you
# a proper XPath expresion ready to be used.
anchor2xpath() {
	local myanch=${1}

	myanch=${myanch//\#doc_/\/\/}
	myanch=${myanch//chap/chapter\[}
	myanch=${myanch//sect/section\[}
	myanch=${myanch//pre/descendant::pre\[}
	myanch=${myanch//fig/descendant::figure\[}
	myanch=${myanch//_/\]\/}
	myanch="${myanch}]"
	myanch=${myanch//\[\]/\[1\]}

	echo ${myanch}
}
