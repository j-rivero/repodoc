CLEANFILES = *~
MAINTAINERCLEANFILES = Makefile.in

SUBDIRS = .

SUBDIRS_DIST = t10004 t20000 t20001 t20002 t20003 t20004

TESTS_ENVIRONMENT = env bash

TESTS = t00000-test-the-testsuite.bash \
		t10000-docpath.bash            \
		t10001-stripxmlcomments.bash   \
		t10002-massagelinenumbers.bash \
		t10003-anchor2xpath.bash       \
		t10004-get-xmltree.bash        \
		t20000-banned.bash             \
		t20001-length.bash             \
		t20002-header.bash             \
		t20003-xml.bash                \
		t20004-utf8.bash

EXTRA_DIST = $(TESTS) $(SUBDIRS_DIST) test-lib.bash test-module-lib.bash
check_DATA = test-lib.bash test-module-lib.bash
