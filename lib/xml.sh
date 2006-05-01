#
# XML Repodoc Lib
#
# Designed to provide some basic functions to handly xml tags and attributes
# on docs designed using guidexml.
#

# GET-XMLTAG Function. Public.
# Extract the xml tag identify by param1
# Params:
# - $1. Label title to found (<title )
# - $2. Doc to parse
#
# Return:
# - valid: all <$title xmltag line until >
# - error: "" if no <$title tag was found on $xmldoc
#
function get-xmltag () {
	local TITLE=${1} XMLDOC=${2} XMLTAG

	# Sanity Check. ¿do params exists?
	[[ -z "${XMLDOC}" ]] || [[ -z "${TITLE}" ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	# Sed to extract the tag <$title from xmldoc avoiding spaces
	XMLTAG=$(sed -n -e "/[[:blank:]]*<${TITLE}.*>[[:blank:]]*/p" ${XMLDOC})

	# Check if the xmltag was found.
	[[ -z ${XMLTAG} ]] && echo "" && return -1

	# Returning result
	echo "${XMLTAG}"
}


# GET-TAGATTRIBUTE. Public
# Extract the attribute from an xml tag
# Params:
#  - $1. Xml tag where look for the attr
#  - $2. Attribute to found
# Return:
# - valid: $attr content (without "") from $xmltag
# - error: "" if no $attr attribute was found on $xmltag
#
function get-tagattribute () {
	local XMLTAG=${1} ATTR=${2} TMP_ATTR

	# Sanity Check. ¿do params exists?
	[[ -z "${XMLTAG}" ]] || [[ -z "${ATTR}" ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	# Delete all before $attr="
	TMP_ATTR=${XMLTAG##*${ATTR}=\"}

	# Check if the attribute was found. TMP_ATTR != XMLTAG -> found
	[[ ${TMP_ATTR} == ${XMLTAG} ]] && echo "" && return -1

	# Delete all after first "
	TMP_ATTR=${TMP_ATTR%%\"*}

	# Return value
	echo "${TMP_ATTR}"
}


# GET-XMLATTRIBUTE. Public
# Extract the attribute from an xml file
# Params:
# - $1. Lable title to found (<title )
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
function get-xmlattribute () {
	local TITLE=${1} ATTR=${2} XMLDOC=${3} XMLTAG ATTR_RESULT

	# Sanity Check. ¿do params exists?
	[[ -z "${TITLE}" ]] || [[ -z "${ATTR}" ]] || [[ -z "${XMLDOC}" ]] \
	&& echo "${FUNCNAME} one of the params is empty" && return -1

	# Call get-xmltag to obtain xml label to found attr
	XMLTAG=$(get-xmltag "${TITLE}" "${XMLDOC}");

	# Call get-tagattribute to obtain the attribute form the xml label
	ATTR_RESULT=$(get-tagattribute "${XMLTAG}" "${ATTR}")

	# Return value
	echo "${ATTR_RESULT}"
}
