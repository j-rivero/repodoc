. ./test-lib.bash

# Test very simple functions
test_expect_pass 'Simple test that only passes (true)' 'true'
test_expect_fail 'Simple test that only fails (false)' 'false'

# This involves more 'machinery'
test_expect_value 0 '0 == $(echo 0)' 'echo 0'
test_expect_ok 'Ok should be 0' 'echo 0'
test_expect_warning 'Warning should be 1' 'echo 1'
test_expect_error 'Error should be 2' 'echo 2'

# Check variables
test_expect_pass '${FILESDIR} == t00000' "[[ ${FILESDIR} == t00000 ]]"

test_done
