#!/usr/bin/env bash
# Distributed under the terms of the GNU General Public License v2
# Copyright 2005-2006 The RepoDoc Team
#  - API and ideas (not actual code) taken from Git's test-suite

LIB_DIR="../lib/"
MODULE_FILE=${0%.bash}
MODULE_FILE=${MODULE_FILE#*-}.module

. ./test-lib.bash
source ../lib/libcore.sh

case ${0} in
	t2*)
		source ../modules/repodoc/"${MODULE_FILE}"
	;;
	t3*)
		source ../modules/docman/"${MODULE_FILE}"
	;;
esac

EXTRA_DIR="../extras"

test_module_expect_pass() {
	[[ -n ${2} ]] && DOC="${FILESDIR}"/"${2}"
	test_expect_pass "${1}" 'exec_module'
}

test_module_expect_fail() {
	[[ -n ${2} ]] && DOC="${FILESDIR}"/"${2}"
	test_expect_fail "${1}" 'exec_module'
}

test_module_expect_ok() {
	[[ -n ${2} ]] && DOC="${FILESDIR}"/"${2}"
	test_expect_return 0 "${1}" 'exec_module'
}

test_module_expect_warning() {
	[[ -n ${2} ]] && DOC="${FILESDIR}"/"${2}"
	test_expect_return 1 "${1}" 'exec_module'
}

test_module_expect_error() {
	[[ -n ${2} ]] && DOC="${FILESDIR}"/"${2}"
	test_expect_return 2 "${1}" 'exec_module'
}
