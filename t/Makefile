#
# Simple Makefile to run all the tests
#
SHELL = /usr/bin/env bash
TEST_OPTS =

TESTS=$(wildcard t[0-5][0-9][0-9][0-9][0-9]-*.bash)

all: $(TESTS)

$(TESTS): test-lib.bash
	@$(SHELL) $@ $(TEST_OPTS)

.PHONY: all $(TESTS)
