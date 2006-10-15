. ./test-module-lib.bash

test_module_expect_ok \
	'Whether it correctly checks UTF-8 files (correct).' \
	'correct'

test_module_expect_error \
	'Whether it correctly checks UTF-8 files (wrong).' \
	'wrong'

test_done
