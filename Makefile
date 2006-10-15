#
# Simple Makefile to run stuff from the top-level directory
#
all:
	$(MAKE) -C extras

check:
	$(MAKE) -C t

clean:
	$(MAKE) -C extras clean

.PHONY: all check clean
