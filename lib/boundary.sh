#
# SHA1SUM boundary
#

boundary() {
	sum=$(sha1sum <<< "${*}")
	echo ${sum%% *}
}
