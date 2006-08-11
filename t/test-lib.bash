#!/usr/bin/env bash
# Distributed under the terms of the GNU General Public License v2
# Copyright 2005-2006 The RepoDoc Team
#  - API and ideas (not actual code) taken from Git's test-suite

say() {
	echo "* ${*}" >&2
}

error() {
	echo "(EE) ${*}" >&2
}

die() {
	echo "Fatal Error: ${1:-(no message provided)}" >&2
	exit 1
}

test_run_() {
	say "${1}"
	# FIXME: Need to use something different for debugging
	eval "${2}" >/dev/null 2>/dev/null
}

test_run__() {
	say "${1}"
	eval "${2}" 2>&1
}

test_expect_value() {
	local r=$(test_run__ "${2}" "${3}")
	if [[ ${r} != ${1} ]] ; then
		((testf++))
		error "While running ..."
		echo "${3}"
		error "... expected:"
		echo "${1}"
		error "... got:"
		echo "${r}"
	else
		((testp++))
	fi
	return $?
}

test_expect_pass() {
	if test_run_ "${1}" "${2}" ; then
		((testp++))
	else
		((testf++))
		error "While running ..."
		echo "${2}"
		error "... got FALSE, expected TRUE:"
	fi
}

test_expect_fail() {
	if test_run_ "${1}" "${2}" ; then
		((testf++))
		error "While running ..."
		echo "${2}"
		error "... got TRUE, expected FALSE:"
	else
		((testp++))
	fi
}

test_expect_ok() {
	test_expect_value 0 "${1}" "${2}"
}

test_expect_warning() {
	test_expect_value 1 "${1}" "${2}"
}

test_expect_error() {
	test_expect_value 2 "${1}" "${2}"
}

test_done() {
	local alltests=$((testp + testf))
	if [[ ${testf} == 0 ]] ; then
		say "all ${alltests} test(s) passed" >&2
	else
		say "${testf} out of ${alltests} test(s) failed" >&2
		die "All ${alltests} test(s) have to pass"
	fi
}

testp=0
testf=0

echo "*** ${0%.bash} ***"