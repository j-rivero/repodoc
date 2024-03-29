#
# XML Repodoc Lib
#
# Provides some basic functionality to handle xml tags and attributes
# on GuideXML documents.
#

needlib xpath.sh

# GET-XMLTAG Function. Public.
# Extract the xml tag identified by its first argument
# Params:
# - $1. Label title to found (<title )
# - $2. Doc to parse
#
# Return:
# - valid: all <$title xmltag line until >
# - error: "" if no <$title tag was found on $xmldoc
#
get-xmltag() {
	local TITLE=${1} XMLDOC=${2} XMLTAG

	# Sanity Check. ¿do params exists?
	[[ -z ${XMLDOC} ]] || [[ -z ${TITLE} ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	# Sed to extract the tag <$title from xmldoc avoiding spaces
	XMLTAG=$(sed -n -f "${LIB_DIR}/stripxmlcomments.sed" \
		-e "/[[:blank:]]*<${TITLE}.*>[[:blank:]]*/p" ${XMLDOC})

	# Check if the xmltag was found.
	[[ -z ${XMLTAG} ]] && echo "" && return -1

	# Returning result
	echo "${XMLTAG}"
}


# GET-TAGATTRIBUTE. Public
# Extract the attribute from an xml tag
# Params:
#  - $1. Xml tag where to look for the attr
#  - $2. Attribute to find
# Return:
# - valid: $attr content (without "") from $xmltag
# - error: "" if no $attr attribute was found on $xmltag
#
get-tagattribute() {
	local XMLTAG=${1} ATTR=${2} TMP_ATTR

	# Sanity Check. ¿do params exists?
	[[ -z ${XMLTAG} ]] || [[ -z ${ATTR} ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	# Delete all before $attr="
	TMP_ATTR=${XMLTAG##*${ATTR}=\"}

	# Check if the attribute was found. TMP_ATTR != XMLTAG -> found
	[[ ${TMP_ATTR} = ${XMLTAG} ]] && echo "" && return -1

	# Delete all after first "
	TMP_ATTR=${TMP_ATTR%%\"*}

	# Return value
	echo "${TMP_ATTR}"
}


# GET-XMLATTRIBUTE. Public
# Extract the attribute from an xml file
# Params:
# - $1. Lable title to find (<title )
# - $2. Attribute inside the label
# - $3. Doc to parse
#
# Return:
# - valid: Attribute value inside title xml tag
# - error: "" if the tag was not found
#
# Use:
# - GET_XMLTAG
# - GET-TAGATTRIBUTE
#
get-xmlattribute() {
	local TITLE=${1} ATTR=${2} XMLDOC=${3}

	# Sanity Check. ¿do params exists?
	[[ -z ${TITLE} ]] || [[ -z ${ATTR} ]] || [[ -z ${XMLDOC} ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	doxpath ${XMLDOC} "//${TITLE}/@${ATTR}"
}

# GET-XMLTREE. Public
# Extract a raw tree from a given XML tree removing things
# we are not interested in such as author, mail and subtress which
# have a 'p' ancestry.
#
# Params:
# - $1. Document
#
# Return:
# - Said tree.
get-xmltree() {
	xmllint --shell $1 <<< 'du' 2>/dev/null | \
		awk -f "${LIB_DIR}/trimtree.awk" | \
		grep -v "/ >\|author\|mail"
}

# GET-XMLDOCTYPE. Public
# Extract the doctype defined by doctype directive.
#
# Params:
# - $1. Document
#
# Return:
# - XML type defined by doctype
get-xmldoctype() {
	local DOC=${1} DOC_TYPE

	# Call to xpatheval to extract the info
	DOC_TYPE=$(doxpath ${DOC} "/child::*[1]")

	echo "${DOC_TYPE}"
}

# SET-XMLTAG. Public
#
#
# Params:
#
# - $1. XML tag to modify
# - $2. NEW value for the tag
# - $3. Document to make the change
#
# Return:
# - Nothing

set-xmltag() {
	local tag=${1} new_value=${2} DOC=${3}

	sed -i -e "s~<${tag}>.*</${tag}>~<${tag}>${new_value}</${tag}>~g" ${DOC}
}
