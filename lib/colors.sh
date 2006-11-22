#
# Some nice colors to source in repodoc
#

if tty -s <&1 ; then
	RED="\033[01;31m"
	GREEN="\033[01;32m"
	YELLOW="\033[01;33m"
	BLUE="\033[01;34m"
	WHITE="\033[01;38m"
	OFF="\033[00m"
else
	RED=
	GREEN=
	YELLOW=
	BLUE=
	WHITE=
	OFF=
fi

red() {
	echo -e "${RED}$*${OFF}"
}

green() {
	echo -e "${GREEN}$*${OFF}"
}

yellow() {
	echo -e "${YELLOW}$*${OFF}"
}

blue() {
	echo -e "${BLUE}$*${OFF}"
}

white() {
	echo -e "${WHITE}$*${OFF}"
}

# Format functions
result_output() {
        local res

        case $1 in
                0)
                        OUTPUT_RESULT=ok
                        res=$(green 'ok')
                ;;
                1)
                        OUTPUT_RESULT=warning
                        res=$(yellow '??')
                ;;
                2)
                        OUTPUT_RESULT=critical
                        res=$(red '!!')
                ;;
        esac

        echo -e "[ ${res} ]"
        return $1
}
