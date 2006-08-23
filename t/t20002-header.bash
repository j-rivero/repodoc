. ./test-module-lib.bash

test_module_expect_warning 'Header tag missing.' 'no-header'
test_module_expect_warning 'Malformed Header tag (1).' 'malformed-header1'
test_module_expect_warning 'Malformed Header tag (2).' 'malformed-header2'
test_module_expect_warning 'Malformed Header tag (3).' 'malformed-header3'
test_module_expect_ok 'Proper Header tag.' 'header'

test_done
