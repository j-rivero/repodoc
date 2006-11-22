#
# Frontend Core
#

# Editable functions
post_read_keys() { :;}
pre_module_result() { :;}
post_module_result() { :;}
post_read_doc() { :;}

# Core functions
read_keys() {
	local key value
	read DOC_SUM
	while read key value; do
		[[ ${key} != ${DOC_SUM} ]] && local ${key}=${value} || break
	done
	[[ -z ${key} ]] && return 1
	post_read_keys
}

read_module() {
	local MOD_NAME MOD_RESULT MOD_OUTPUT
	read MOD_NAME
	[[ -z ${MOD_NAME} ]] && return 1
	pre_module_result
	read MOD_RESULT
	while read; do
		case ${REPLY} in
			${DOC_SUM})
				break
			;;
			${DOCS_SUM})
				post_module_result
				return 1
			;;
			*)
				MOD_OUTPUT="${MOD_OUTPUT}
${REPLY}"
			;;
		esac
	done
	post_module_result
	return 0
}

# Init Function
init_frontend() {
	# Read sums
	read DOCS_SUM
	while read_keys; do
		while read_module; do :; done
		post_read_doc
	done
}
