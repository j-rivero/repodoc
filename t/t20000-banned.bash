. ./test-module-lib.bash

REPO_CONF_DIR="${FILESDIR}"
LANGUAGE="en"

test_module_expect_ok 'Correct paragraph.' 'correct'
test_module_expect_error 'Paragraph whith tabulation.' 'tab'
test_module_expect_error 'Paragraph whith trailing white space.' \
		'trailingwhitespaces'
test_module_expect_ok 'Simple test for pattern file.' 'simple-good'
test_module_expect_error 'Simple pattern, start line.' 'simple-bad-start'
test_module_expect_error 'Simple pattern, in line.' 'simple-bad-in'
test_module_expect_error 'Simple pattern, end line.' 'simple-bad-end'
test_module_expect_error 'Special pattern.' 'special'

test_done
