. ./test-module-lib.bash

test_module_expect_ok \
	'Whether it correctly checks XML files (wellformed).' \
	'wellformed.xml'

test_module_expect_error \
	'Whether it correctly checks XML files (malformed).' \
	'malformed.xml'

test_done
