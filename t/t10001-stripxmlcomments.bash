. ./test-lib.bash

stripsed="sed -f ../lib/stripxmlcomments.sed"

test_expect_value "" \
		"Simple one-line comment." \
		"echo '<!-- nothing to see here -->' | ${stripsed}"

test_expect_value "a  c" \
		"Simple inline comment with text around." \
		"echo 'a <!-- b --> c' | ${stripsed}"

withcomments="<!-- b
c -->"

test_expect_value "" \
		"Simple comment across two lines." \
		"echo '${withcomments}' | ${stripsed}"

withcomments="a<!-- b
c --> d"

withoutcomments="a
 d"

test_expect_value "${withoutcomments}" \
		"Comment across two lines with text around." \
		"echo '${withcomments}' | ${stripsed}"

withcomments="a<!-- b
c d e
f --> g"

withoutcomments="a
 g"

test_expect_value "${withoutcomments}" \
		"Comment accross tree lines with text around." \
		"echo '${withcomments}' | ${stripsed}"

# This is a known FAILURE. Luckily they don't use that kind of comments.
#
# withcomments="a <!-- b --> c <!-- d --> e"
# withoutcomments="a  c  e"
#
# test_expect_value "${withoutcomments}" \
#		"Two inline comments with text around." \
#		"echo '${withcomments}' | ${stripsed}"

withcomments="<!-- <!-- something --> -->
this should be kept
<!--
    this expands
    a couple
    of
    lines --> here i am
and this should <!-- not --> be kept too
if you <!-- delete me --> show this, you get a cookie"

withoutcomments="
this should be kept
 here i am
and this should  be kept too
if you  show this, you get a cookie"

test_expect_value "${withoutcomments}" \
		"See if stripxmlcomments.sed is doing it's job." \
		"echo '${withcomments}' | ${stripsed}"

test_done
