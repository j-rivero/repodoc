. ./test-module-lib.bash

test_module_expect_ok 'Simple short lines.' 'simple-short-lines'
test_module_expect_warning 'One long line.' 'one-long-line'
test_module_expect_ok 'Skip one pre block.' 'skip-pre-blocks'
test_module_expect_warning 'Skip JUST one pre block.' \
		'skip-just-one-pre-block'
test_module_expect_ok 'Skip <!-- $Header: --> lines.' 'ignore-header'
test_module_expect_warning 'Malformed long <uri lines (1).' \
		'malformed-links1'
test_module_expect_warning 'Malformed long <uri lines (2).' \
		'malformed-links2'
test_module_expect_ok 'Very long <uri>link</uri> lines.' \
		'long-links1'
test_module_expect_ok 'Very long link="" lines.' 'long-links2'
test_module_expect_ok "<title>'s should be ignored." 'titles'
test_module_expect_ok "<guide>'s should be ignored." 'guides'

test_done
