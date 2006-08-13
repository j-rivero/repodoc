. ./test-lib.bash

LIB_DIR="../lib"
source "../lib/libcore.sh"
needlib xml.sh

test_expect_pass 'Is trimtree.awk working properly?' \
		"get-xmltree '${FILESDIR}'/input.xml > '${FILESDIR}'/output &&
		cmp -s '${FILESDIR}'/output '${FILESDIR}'/expected"

rm "${FILESDIR}"/output

test_done
