#
# DOCPATHS Repodoc Lib
#
# Provides some basic functionality to extract info from the path
# of a doc
#

# EXTRACT-DOC-DOMAIN Function. Public.
#
# Extract the domain where the doc is placed. Domain could be
# doc, proj, main ... Is the first path item after /htdocs/
# e.g: /home/foo/gentoo/xml/htdocs/doc/es/foo.xml
#      DOMAIN = doc
#
# Params:
# - $1. Full doc system path
#
# Return:
# - domain without slashes [ doc | proj | main | ... ]
#

extract-doc-domain(){
	local DOC_PATH=${1} DOMAIN

	# The dir root is the first cvs tree subdir after htdocs
	DOMAIN=${DOC_PATH##*htdocs\/}
	DOMAIN=${DOMAIN%%\/*}

	echo "${DOMAIN}"
}

# EXTRACT-DOC-LANGUAGE Function. Public.
#
# Extract the doc language. Language is a two letter id:
# en, es ... Is the next item in the path after domain
# e.g: /home/foo/gentoo/xml/htdocs/doc/es/foo.xml
#      LANGUAGE = es
#
# Params:
# - $1. Full doc system path
#
# Return:
# - two letters language id [ en | es | ... ]
#

extract-doc-language() {
	local DOC_PATH=${1} LANGUAGE

	# The language always appear after /htdocs/domain/LANGUAGE/ so
	# remove all from the start to htdocs/*/
	LANGUAGE=${DOC_PATH#*htdocs\/*\/}

	# Remove the useless rest of the path
	LANGUAGE=${LANGUAGE%%/*}

	echo "${LANGUAGE}"
}

# EXTRACT-WEB-DIR Function. Public.
#
# Extract the dir after www.gentoo.org where the doc will be available.
# It's the full path after /htdocs/ excluding the own file.
# e.g: /home/foo/gentoo/xml/htdocs/doc/es/foo.xml
#      WEB_DIR = /doc/es
#
# Params:
# - $1. Full doc system path
#
# Return:
# - web dir including beggining slash
#

extract-web-dir() {
	local DOC_PATH=${1} WEB_DIR

	# Obtaining the www dir where the doc is placed
	WEB_DIR=${DOC_PATH##*htdocs\/}

	# Include starting slash "/"
	echo "/${WEB_DIR}"
}

# EXTRACT-CVS-ROOT Function. Public.
#
# Extract the 'real' cvs root. Real means important dirs
# when you work with docs. The real root is full doc path
# until /htdocs/.
# e.g: /home/foo/gentoo/xml/htdocs/doc/es/foo.xml
#      CVS_ROOT = /home/foo/gentoo/xml/htdocs
#
# Params:
# - $1. Full doc system path
#
# Return:
# - system dir starting with a slash and finish in htdocs without
# a slash.
#

extract-cvs-root() {
	local DOC_PATH=${1} CVS_ROOT

	CVS_ROOT=${DIR/htdocs\/*/htdocs}

	echo ${CVS_ROOT}
}

# LOCALIZE-PATH Function. Public.
#
# Changes the given path to the given language.
#
# Params:
# - $1. The full doc path.
# - $2. New language to apply
#
# Result:
# - full doc path with the language changed.

localize-path() {
	local DOC_PATH=${1} NEW_LANGUAGE=${2} CURRENT_LANGUAGE DOC_LOCALIZED

	# Obtain the current language
	CURRENT_LANGUAGE=$(extract-doc-language ${DOC_PATH})

	DOC_LOCALIZED=${DOC_PATH//\/${CURRENT_LANGUAGE}\//\/${NEW_LANGUAGE}\/}

	echo "${DOC_LOCALIZED}"
}
