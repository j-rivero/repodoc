. ./test-lib.bash

LIB_DIR="../lib/"
source ../lib/libcore.sh
needlib docpath.sh

docpath="/home/bob/something/gentoo/xml/htdocs/doc/en/devfs-guide.xml"

test_expect_value 'doc' \
		'Extract the domain where the document is placed.' \
		"extract-doc-domain ${docpath}"

test_expect_value 'en' \
		'Extract language of the document from its path.' \
		"extract-doc-language ${docpath}"

test_expect_value '/doc/en/devfs-guide.xml' \
		'Extract web-dir from the path' \
		"extract-web-dir ${docpath}"

test_expect_value '/home/bob/something/gentoo/xml/htdocs' \
		'Extract CVS root information' \
		"extract-cvs-root ${docpath}"

test_expect_value '/home/bob/something/gentoo/xml/htdocs/doc/es/devfs-guide.xml' \
		'Localize path into spanish (es)' \
		"localize-path ${docpath} es"

test_done
