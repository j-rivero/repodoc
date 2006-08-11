. ./test-lib.bash

LIB_DIR="../lib/"
source "../lib/libcore.sh"
needlib xpath.sh

test_expect_value '//chapter[2]' \
		'Simple numbered chapter.' \
		'anchor2xpath "#doc_chap2"'

test_expect_value '//chapter[1]' \
		'Simple unnumbered chapter.' \
		'anchor2xpath "#doc_chap"'

test_expect_value '//chapter[1]/section[5]/descendant::figure[1]' \
		'Numbered chapter, numbered section and unnumbered figure.' \
		'anchor2xpath "#doc_chap_sect5_fig"'

test_expect_value '//chapter[2]/section[1]' \
		'Numbered chapter, unnumbered section.' \
		'anchor2xpath "#doc_chap2_sect"'

test_expect_value '//chapter[1]/section[1]' \
		'Unnumbered chapter and section.' \
		'anchor2xpath "#doc_chap_sect"'

test_expect_value '//chapter[4]/section[2]/descendant::pre[4]' \
		'Numbered chapter, section and pre.' \
		'anchor2xpath "#doc_chap4_sect2_pre4"'

test_done
