#
# Some nice colors to source in repodoc
#
RED="\033[01;31m"
GREEN="\033[01;32m"
YELLOW="\033[01;33m"
BLUE="\033[01;34m"
WHITE="\033[01;38m"
OFF="\033[00m"

red() {
	echo -e ${RED}$*${OFF}
}

green() {
	echo -e ${GREEN}$*${OFF}
}

yellow() {
	echo -e ${YELLOW}$*${OFF}
}

blue() {
	echo -e ${BLUE}$*${OFF}
}

white() {
	echo -e ${WHITE}$*${OFF}
}
