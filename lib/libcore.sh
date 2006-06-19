#
# Provides basic lib functionality
#

needlib() {
	local lib

	[[ -z ${@} ]] && return

	[[ -z ${SOURCED} ]] && SOURCED="libcore.sh"

	for lib in ${@} ; do
		if [[ -n ${SOURCED//*${lib}*} ]] ; then
			if ! source "${LIB_DIR}/${lib}" 2>/dev/null ; then
				echo >&2 "(EE) ${lib} does not exist in ${LIB_DIR}"
				exit 1
			fi
			SOURCED="${SOURCED} ${lib}"
		fi
	done
}
