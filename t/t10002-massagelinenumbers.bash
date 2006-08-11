. ./test-lib.bash

massagesed="sed -f ../lib/massagelinenumbers.sed"

inp="17
  Something here."

out="17	Something here."

test_expect_value "${out}" \
		"Simple line with one number and two spaces." \
		"echo '${inp}' | ${massagesed}"

inp="23
  This is a line
35
 This is another line with one space less.
100
I have no spaces"

out="23	This is a line
35	This is another line with one space less.
100	I have no spaces"

test_expect_value "${out}" \
		"Some lines with different spacing." \
		"echo '${inp}' | ${massagesed}"

test_done
